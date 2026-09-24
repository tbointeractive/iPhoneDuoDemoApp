import SwiftUI

/// Secondary content of the overlay arrangement — stands in for a video surface.
struct StagePane: View {
    @Environment(PlayerModel.self) private var player

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [(player.station?.tint ?? .gray).opacity(0.9), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 8) {
                Image(systemName: "video.fill")
                    .font(.system(size: 48))
                Text("Bühne")
                    .font(.headline)
                Text("Unter dem Bedienfeld — bis das Arrangement die beiden trennt.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .foregroundStyle(.white)
        }
        .ignoresSafeArea()
    }
}

/// Primary content of the overlay arrangement: the controls that sit on top.
struct PlaybackControlsPane: View {
    @Environment(PlayerModel.self) private var player

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 24) {
                Button("Zurück", systemImage: "backward.fill") { player.skipBackward() }
                Button(player.isPlaying ? "Pause" : "Wiedergabe",
                       systemImage: player.isPlaying ? "pause.fill" : "play.fill") {
                    player.togglePlayPause()
                }
                Button("Vor", systemImage: "forward.fill") { player.skipForward() }
            }
            .labelStyle(.iconOnly)
            .font(.title3)

            ProgressView(value: player.progress)

            if #available(iOS 27.1, *) {
                OverlayZIndexLabel()
            }
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 24))
        .padding()
    }
}

/// The z-index the overlay arrangement assigned to this pane.
@available(iOS 27.1, *)
private struct OverlayZIndexLabel: View {
    @Environment(\.overlayArrangementZIndex) private var zIndex

    var body: some View {
        Text("z-Index im Overlay: \(String(describing: zIndex))")
            .font(.caption2)
            .foregroundStyle(.secondary)
    }
}

@available(iOS 27.1, *)
#Preview {
    ArrangementView {
        PlaybackControlsPane()
            .overlayArrangementEdge(.trailing)
    } secondary: {
        StagePane()
    }
    .arrangementViewStyle(.overlay)
    .environment(PlayerModel())
}
