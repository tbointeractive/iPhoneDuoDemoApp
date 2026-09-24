import SwiftUI

@main
struct DuoKitShowcaseApp: App {
    @State private var player = PlayerModel()
    @State private var diagnostics = DiagnosticsModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(player)
                .environment(diagnostics)
        }
    }
}
