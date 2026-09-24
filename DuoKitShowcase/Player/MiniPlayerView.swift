import SwiftUI

/// The container above the tab bar — the reason this demo exists.
///
/// `tabViewBottomAccessory` hangs the player off the `TabView` itself, so it
/// outlives tab switches and pushes inside a tab. The system decides where it
/// sits and tells the content through `tabViewBottomAccessoryPlacement`:
/// `.expanded` above a full-height tab bar, `.inline` inside a minimized one.
/// The two layouts below are the same player at two heights.
struct MiniPlayerView: View {
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement
    @Environment(PlayerModel.self) private var player

    var body: some View {
        // `placement` is optional; compare rather than switch so the undefined
        // case falls through to the roomier layout.
        if placement == .inline {
            inlinePlayer
        } else {
            expandedPlayer
        }
    }

    private var inlinePlayer: some View {
        HStack(spacing: 8) {
            artwork(size: 22)
            Text(title)
                .font(.caption)
                .lineLimit(1)
            Spacer(minLength: 4)
            playPauseButton
                .font(.body)
        }
        .padding(.horizontal, 12)
    }

    private var expandedPlayer: some View {
        HStack(spacing: 12) {
            artwork(size: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            HStack(spacing: 20) {
                playPauseButton
                Button("15 Sekunden vor", systemImage: "goforward.15") {
                    player.skipForward()
                }
                .labelStyle(.iconOnly)
                .disabled(player.station == nil)
            }
            .font(.title3)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
    }

    private var playPauseButton: some View {
        Button(player.isPlaying ? "Pause" : "Wiedergabe",
               systemImage: player.isPlaying ? "pause.fill" : "play.fill") {
            player.togglePlayPause()
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .disabled(player.station == nil)
    }

    private func artwork(size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: size / 4)
            .fill((player.station?.tint ?? .gray).gradient)
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: player.station?.symbolName ?? "radio")
                    .font(.system(size: size * 0.5))
                    .foregroundStyle(.white)
            }
    }

    private var title: String {
        player.station == nil ? "Nichts ausgewählt" : player.trackTitle
    }

    private var subtitle: String {
        player.station?.name ?? "Im Sender-Tab etwas starten"
    }
}

#Preview {
    TabView {
        Tab("Sender", systemImage: "dot.radiowaves.left.and.right") {
            Text("Inhalt")
        }
    }
    .tabViewBottomAccessory {
        MiniPlayerView()
    }
    .environment(PlayerModel())
}
