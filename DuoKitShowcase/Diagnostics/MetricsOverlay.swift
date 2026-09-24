import SwiftUI

extension View {
    /// Attaches the floating live-metrics panel and its toggle.
    func metricsOverlay() -> some View {
        modifier(MetricsOverlayModifier())
    }
}

/// Puts the debug panel over the app without taking part in its layout.
private struct MetricsOverlayModifier: ViewModifier {
    @Environment(DiagnosticsModel.self) private var diagnostics

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                if diagnostics.isOverlayVisible {
                    MetricsPanel()
                        .transition(.move(edge: .leading).combined(with: .opacity))
                } else {
                    toggleChip
                }
            }
            .animation(.smooth(duration: 0.25), value: diagnostics.isOverlayVisible)
    }

    private var toggleChip: some View {
        Button {
            diagnostics.isOverlayVisible = true
        } label: {
            Image(systemName: "ruler")
                .font(.footnote)
                .padding(8)
        }
        .buttonStyle(.plain)
        .glassEffect(in: .circle)
        .padding(.leading, 8)
        .padding(.top, 104)
        .accessibilityLabel("Diagnose einblenden")
    }
}

/// Everything the layout resolved to, right now.
///
/// Read live from the view tree instead of cached in the model, so the numbers
/// are whatever this layout pass produced — including mid-fold.
private struct MetricsPanel: View {
    @Environment(DiagnosticsModel.self) private var diagnostics
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 4) {
                header

                MetricRow("H-Klasse", Self.name(for: horizontalSizeClass))
                MetricRow("V-Klasse", Self.name(for: verticalSizeClass))
                MetricRow("Fläche", "\(Int(proxy.size.width)) × \(Int(proxy.size.height))")
                MetricRow("Safe Area", Self.description(for: proxy.safeAreaInsets))

                Divider().padding(.vertical, 2)

                MetricRow("Scharnier", diagnostics.hingeStatusDescription)
                MetricRow("Winkel", diagnostics.hingeAngleDescription)

                if #available(iOS 27.1, *) {
                    DuoMetricRows(proxy: proxy)
                } else {
                    MetricRow("Duo-Metriken", "ab iOS 27.1")
                }
            }
            .font(.caption2.monospacedDigit())
            .padding(10)
            .frame(width: 250, alignment: .leading)
            .background(.regularMaterial, in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color(.separator))
            }
        }
        .frame(width: 250, height: 260)
        // Clears a large-title navigation bar. A debug panel, not a layout
        // citizen — it deliberately does not participate in the safe area.
        .padding(.leading, 8)
        .padding(.top, 104)
    }

    private var header: some View {
        HStack {
            Text("Live-Metriken")
                .font(.caption.bold())
            Spacer()
            Button("Schließen", systemImage: "xmark") {
                diagnostics.isOverlayVisible = false
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .font(.caption2)
        }
        .padding(.bottom, 2)
    }

    private static func name(for sizeClass: UserInterfaceSizeClass?) -> String {
        guard let sizeClass else { return "—" }
        return sizeClass == .regular ? "regular" : "compact"
    }

    private static func description(for insets: EdgeInsets) -> String {
        let values = [insets.top, insets.leading, insets.bottom, insets.trailing]
        return values.map { String(Int($0.rounded())) }.joined(separator: "/")
    }
}

/// The rows whose sources — vertical bar edge and reserved regions — are iOS 27.1 API.
@available(iOS 27.1, *)
private struct DuoMetricRows: View {
    let proxy: GeometryProxy

    @Environment(\.toolbarVerticalEdge) private var toolbarVerticalEdge

    var body: some View {
        let divisions = proxy.reservedRegions(kind: .division, options: [.includeInactive])
        let occlusions = proxy.reservedRegions(kind: .occlusion, options: [.includeInactive])

        MetricRow("Vert. Leiste", Self.name(for: toolbarVerticalEdge))
        MetricRow("Teilungen", "\(divisions.count) (\(divisions.filter(\.isActive).count) aktiv)")
        MetricRow("Verdeckungen", "\(occlusions.count) (\(occlusions.filter(\.isActive).count) aktiv)")
    }

    private static func name(for edge: HorizontalEdge?) -> String {
        guard let edge else { return "keine" }
        return edge == .leading ? "leading" : "trailing"
    }
}

private struct MetricRow: View {
    let label: String
    let value: String

    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer(minLength: 8)
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    Color.blue
        .metricsOverlay()
        .environment(DiagnosticsModel())
}
