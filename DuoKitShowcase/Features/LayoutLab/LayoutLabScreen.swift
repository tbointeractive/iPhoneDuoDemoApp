import SwiftUI

/// Hosts the reserved-region canvas, which needs iOS 27.1.
struct LayoutLabScreen: View {
    @State private var showsOcclusions = true
    @State private var showsDivisions = true
    @State private var includesInactive = true
    @State private var verticalBarDisabled = true

    var body: some View {
        NavigationStack {
            // Keeps the bar inset readable: the canvas below deliberately draws
            // under the bars, so the legend needs the value the canvas discards.
            GeometryReader { proxy in
                content(legendTopInset: proxy.safeAreaInsets.top)
                    .ignoresSafeArea()
            }
            .navigationTitle("Layout-Labor")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Toggle(isOn: $showsDivisions) { Label("Teilungen", systemImage: "square.split.2x1") }
                    Toggle(isOn: $showsOcclusions) { Label("Verdeckungen", systemImage: "camera") }
                    Toggle(isOn: $includesInactive) { Label("Inaktive zeigen", systemImage: "eye.slash") }
                }
            }
        }
        // A full-bleed, non-scrolling canvas is one of the cases Apple names for
        // opting out of the vertical bar: bar content falls back to the plain
        // horizontal top and bottom toolbars.
        .modifier(VerticalToolbarDisabled(isDisabled: verticalBarDisabled))
    }

    @ViewBuilder
    private func content(legendTopInset: CGFloat) -> some View {
        if #available(iOS 27.1, *) {
            ReservedRegionCanvas(
                showsDivisions: showsDivisions,
                showsOcclusions: showsOcclusions,
                includesInactive: includesInactive,
                verticalBarDisabled: $verticalBarDisabled,
                legendTopInset: legendTopInset
            )
        } else {
            ContentUnavailableView {
                Label("Braucht iOS 27.1", systemImage: "square.split.2x1")
            } description: {
                Text("Reservierte Bereiche gibt es erst ab iOS 27.1. Auf diesem System bleibt das Labor leer.")
            }
        }
    }
}

/// Opts out of the vertical toolbar where that API exists.
private struct VerticalToolbarDisabled: ViewModifier {
    let isDisabled: Bool

    func body(content: Content) -> some View {
        if #available(iOS 27.1, *) {
            content.toolbarVerticalBehavior(isDisabled ? .disabled : .automatic)
        } else {
            content
        }
    }
}

/// Draws the reserved regions that intersect this view.
///
/// Two kinds exist: `.division`, where content is split into separate parts —
/// the fold of a hinge — and `.occlusion`, where hardware covers content, such
/// as the Dynamic Island or a camera. Querying with `.includeInactive` also
/// returns the ones that are currently dormant, which is what makes the fold
/// visible while the device is flat.
@available(iOS 27.1, *)
private struct ReservedRegionCanvas: View {
    let showsDivisions: Bool
    let showsOcclusions: Bool
    let includesInactive: Bool
    /// Lives in the legend, not the toolbar: switching it off rearranges the
    /// toolbar, and a control that moves itself into an overflow popover cannot
    /// be used to switch back.
    @Binding var verticalBarDisabled: Bool
    /// Height of the bars this canvas draws under, so the legend can clear them.
    let legendTopInset: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let options: ReservedRegion.QueryOptions = includesInactive ? [.includeInactive] : []
            let divisions = proxy.reservedRegions(kind: .division, options: options)
            let occlusions = proxy.reservedRegions(kind: .occlusion, options: options)

            ZStack(alignment: .topLeading) {
                backdrop

                if showsDivisions {
                    ForEach(divisions) { region in
                        RegionMarker(region: region, tint: .orange, label: "division")
                    }
                }

                if showsOcclusions {
                    ForEach(occlusions) { region in
                        RegionMarker(region: region, tint: .cyan, label: "occlusion")
                    }
                }

                legend(divisions: divisions.count, occlusions: occlusions.count, size: proxy.size)
            }
        }
    }

    private var backdrop: some View {
        // A regular grid, so a region crossing it is easy to spot from the back row.
        Canvas { context, size in
            let step: CGFloat = 24
            var path = Path()
            var x: CGFloat = 0
            while x <= size.width {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                x += step
            }
            var y: CGFloat = 0
            while y <= size.height {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                y += step
            }
            context.stroke(path, with: .color(.secondary.opacity(0.18)), lineWidth: 0.5)
        }
    }

    private func legend(divisions: Int, occlusions: Int, size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Reservierte Bereiche")
                .font(.headline)
            LabeledContent("Teilungen", value: "\(divisions)")
            LabeledContent("Verdeckungen", value: "\(occlusions)")
            LabeledContent("Fläche", value: "\(Int(size.width)) × \(Int(size.height))")
            Text("Auf einem Gerät ohne Scharnier bleibt die Teilungsliste leer — das ist der Normalfall, kein Fehler.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()
                .padding(.vertical, 4)

            Toggle("Vertikale Leiste aus", isOn: $verticalBarDisabled)
            LabeledContent("Modifier", value: verticalBarDisabled ? ".disabled" : ".automatic")
            Text(verticalBarBadge)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .toggleStyle(.switch)
        .font(.caption.monospacedDigit())
        .padding(12)
        .frame(maxWidth: 280, alignment: .leading)
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
        .padding(.top, legendTopInset + 16)
        // Clears the diagnostics chip, which is pinned in window space at x 13–38.
        .padding(.leading, 48)
    }

    private var verticalBarBadge: String {
        if verticalBarDisabled {
            return """
            Dieser Screen setzt .toolbarVerticalBehavior(.disabled). Leisten- und \
            Tab-Inhalte liegen deshalb waagerecht wie auf einem normalen iPhone — \
            das ist hier die Ausnahme, nicht das übliche Duo-Verhalten. Umschalten \
            und vergleichen.
            """
        }
        return """
        .automatic — das Duo darf Leisten- und Tab-Inhalte auf die vertikale Leiste \
        legen. So sehen die übrigen Screens der App aus.
        """
    }
}

/// Outlines a single reserved region, with its margins drawn separately.
@available(iOS 27.1, *)
private struct RegionMarker: View {
    let region: ReservedRegion
    let tint: Color
    let label: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .strokeBorder(tint, style: StrokeStyle(lineWidth: 2, dash: region.isActive ? [] : [6, 4]))
                .background(tint.opacity(region.isActive ? 0.18 : 0.06))
                .frame(width: region.frame.width, height: region.frame.height)
                .position(x: region.frame.midX, y: region.frame.midY)

            Text("\(label)\(region.isActive ? "" : " (inaktiv)")")
                .font(.caption2.bold())
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(tint, in: .capsule)
                .foregroundStyle(.black)
                // Below the region, not inside it: an occlusion sits in the status
                // bar, and a badge placed at its top edge lands on the clock.
                .offset(x: region.frame.minX + 4, y: region.frame.maxY + 4)
        }
    }
}

#Preview {
    LayoutLabScreen()
}
