import SwiftUI

/// The app shell.
///
/// Everything a foldable exercises at the top level lives here: the tab bar
/// (which becomes a sidebar when the size class allows it), the bottom
/// accessory that carries the mini player, and the single place that observes
/// the hinge for the whole app.
struct RootView: View {
    @Environment(DiagnosticsModel.self) private var diagnostics
    @State private var selection: AppTab = .stations

    var body: some View {
        TabView(selection: $selection) {
            Tab("Sender", systemImage: "dot.radiowaves.left.and.right", value: AppTab.stations) {
                StationsScreen()
            }

            Tab("Podcasts", systemImage: "waveform", value: AppTab.podcasts) {
                PodcastsScreen()
            }

            Tab("Wiedergabe", systemImage: "play.rectangle.on.rectangle", value: AppTab.nowPlaying) {
                NowPlayingScreen()
            }

            Tab("Layout-Labor", systemImage: "square.split.2x1", value: AppTab.layoutLab) {
                LayoutLabScreen()
            }

            Tab("Scharnier", systemImage: "angle", value: AppTab.hinge) {
                HingeScreen()
            }

            Tab("Suche", systemImage: "magnifyingglass", value: AppTab.search, role: .search) {
                SearchScreen()
            }
        }
        // On the inner display both size classes are regular, so the tab bar
        // resolves to a sidebar without any code asking for a device name.
        .tabViewStyle(.sidebarAdaptable)
        // Gives content back the tab bar's height while scrolling. iPhone only,
        // so it simply does nothing once the bar has become a sidebar.
        .tabBarMinimizeBehavior(.onScrollDown)
        // The mini player. It survives tab switches because it lives on the
        // TabView, not inside any one tab.
        .tabViewBottomAccessory {
            MiniPlayerView()
        }
        // One hinge observer for the whole app.
        .modifier(HingeObservation(diagnostics: diagnostics))
        .metricsOverlay()
    }
}

/// Observes the hinge where the API exists — a no-op below iOS 27.1.
private struct HingeObservation: ViewModifier {
    let diagnostics: DiagnosticsModel

    func body(content: Content) -> some View {
        if #available(iOS 27.1, *) {
            // The closure is not actor isolated, so the value is handed to the
            // main actor explicitly.
            content.onHingeChange { _, newContext in
                let snapshot = HingeSnapshot(newContext.hinge)
                Task { @MainActor in
                    diagnostics.hinge = snapshot
                }
            }
        } else {
            content
        }
    }
}

#Preview {
    RootView()
        .environment(PlayerModel())
        .environment(DiagnosticsModel())
}
