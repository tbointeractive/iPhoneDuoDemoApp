import SwiftUI

/// Live hinge readout.
///
/// The hinge is for interactions and effects — a highlight that follows the
/// angle, a control that appears once the device is propped up. It is *not* the
/// input for layout decisions; those belong to size classes, the available size
/// and reserved regions. Reading the angle to decide on a column count is how
/// an app ends up with a layout that is right for exactly one device.
struct HingeScreen: View {
    @Environment(DiagnosticsModel.self) private var diagnostics

    var body: some View {
        NavigationStack {
            Group {
                if let hinge = diagnostics.hinge {
                    readout(for: hinge)
                } else {
                    ContentUnavailableView {
                        Label("Kein Scharnier", systemImage: "iphone.gen3")
                    } description: {
                        Text("""
                        Dieses Gerät meldet kein Scharnier. Auf allem außer einem \
                        iPhone Duo — und vor iOS 27.1, wo es die API noch nicht \
                        gibt — bleibt der Wert leer; der Rest der App läuft \
                        unverändert weiter.
                        """)
                    }
                }
            }
            .navigationTitle("Scharnier")
        }
    }

    private func readout(for hinge: HingeSnapshot) -> some View {
        VStack(spacing: 32) {
            angleDial(for: hinge)

            VStack(spacing: 6) {
                Text(diagnostics.hingeAngleDescription)
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                Text(hinge.statusDescription)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Text("""
            Der Winkel eignet sich für Effekte und Interaktionen. Für Layout \
            entscheiden Größenklassen, verfügbare Fläche und reservierte Bereiche.
            """)
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
        }
        .padding()
        .animation(.smooth, value: hinge.degrees)
    }

    /// Two panels that open along with the physical hinge — the kind of effect
    /// the angle is meant for.
    private func angleDial(for hinge: HingeSnapshot) -> some View {
        let clamped = min(max(hinge.degrees, 0), 180)
        return HStack(spacing: 0) {
            panel
                .rotation3DEffect(.degrees(-(180 - clamped) / 2), axis: (x: 0, y: 1, z: 0), anchor: .trailing)
            panel
                .rotation3DEffect(.degrees((180 - clamped) / 2), axis: (x: 0, y: 1, z: 0), anchor: .leading)
        }
        .frame(height: 160)
    }

    private var panel: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.accentColor.gradient)
            .frame(width: 90, height: 150)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.white.opacity(0.3))
            }
    }
}

#Preview {
    HingeScreen()
        .environment(DiagnosticsModel())
}
