import SwiftUI

/// Primary content of the split arrangement: artwork plus transport controls.
struct NowPlayingPane: View {
    @Environment(PlayerModel.self) private var player

    var body: some View {
        VStack(spacing: 20) {
            artwork

            VStack(spacing: 4) {
                Text(player.trackTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text(player.station?.name ?? "Kein Sender")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: player.progress)
                .tint(player.station?.tint ?? .accentColor)

            transportControls

            if #available(iOS 27.1, *) {
                SplitAxisLabel()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }

    private var artwork: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill((player.station?.tint ?? .gray).gradient)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 260)
            .overlay {
                Image(systemName: player.station?.symbolName ?? "radio")
                    .font(.system(size: 64))
                    .foregroundStyle(.white.opacity(0.9))
            }
    }

    private var transportControls: some View {
        HStack(spacing: 32) {
            Button("15 Sekunden zurück", systemImage: "gobackward.15") {
                player.skipBackward()
            }
            Button(player.isPlaying ? "Pause" : "Wiedergabe",
                   systemImage: player.isPlaying ? "pause.circle.fill" : "play.circle.fill") {
                player.togglePlayPause()
            }
            .font(.system(size: 44))
            Button("15 Sekunden vor", systemImage: "goforward.15") {
                player.skipForward()
            }
        }
        .labelStyle(.iconOnly)
        .font(.title2)
        .buttonStyle(.plain)
        .disabled(player.station == nil)
    }
}

/// Reads `splitArrangementAxis` so the pane reports the axis the arrangement
/// chose, instead of guessing from its own width.
@available(iOS 27.1, *)
private struct SplitAxisLabel: View {
    @Environment(\.splitArrangementAxis) private var arrangementAxis

    var body: some View {
        Label(axisDescription, systemImage: "square.split.2x1")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private var axisDescription: String {
        guard let arrangementAxis else { return "Kein Split-Arrangement" }
        return arrangementAxis == .horizontal ? "Split-Achse: horizontal" : "Split-Achse: vertikal"
    }
}

#Preview {
    NowPlayingPane()
        .environment(PlayerModel())
}
