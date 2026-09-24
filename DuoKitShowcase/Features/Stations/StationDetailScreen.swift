import SwiftUI

/// The detail column of the master–detail pair.
///
/// Also the place where the vertical bar is demonstrated: on iPhone Duo the
/// system may move bar content onto a vertical axis, and toolbar items can say
/// which axis they belong on.
struct StationDetailScreen: View {
    let station: Station
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    @Environment(PlayerModel.self) private var player

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                Text(station.description)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)

                statsGrid

                GroupBox("Vertikale Leiste") {
                    VStack(alignment: .leading, spacing: 6) {
                        if #available(iOS 27.1, *) {
                            VerticalEdgeReadout()
                        } else {
                            LabeledContent("Bevorzugte Kante", value: "braucht iOS 27.1")
                        }
                        Text("""
                        Klappt das Gerät auf, kann das System Leisteninhalte auf die \
                        vertikale Achse legen. Der Teilen-Knopf unten ist mit \
                        .horizontalOnly festgenagelt, die Wiedergabe-Gruppe darf mit \
                        .verticalPreferred mitwandern.
                        """)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle(station.name)
        .navigationSubtitle(station.tagline)
        .toolbar {
            if #available(iOS 27.1, *) {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    favoriteButton
                    playButton
                }
                // May move onto the vertical bar when the system offers one.
                .axisBehavior(.verticalPreferred)

                ToolbarItem(placement: .topBarTrailing) {
                    shareLink
                }
                // Stays on the horizontal bar whatever the system prefers.
                .axisBehavior(.horizontalOnly)
            } else {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    favoriteButton
                    playButton
                    shareLink
                }
            }
        }
    }

    private var favoriteButton: some View {
        Button(isFavorite ? "Favorit entfernen" : "Als Favorit merken",
               systemImage: isFavorite ? "star.fill" : "star",
               action: onToggleFavorite)
    }

    private var playButton: some View {
        Button("Abspielen", systemImage: "play.fill") {
            player.play(station)
        }
    }

    private var shareLink: some View {
        ShareLink(item: "Ich höre gerade \(station.name) auf \(station.frequency)")
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(station.tint.gradient)
                .frame(width: 96, height: 96)
                .overlay {
                    Image(systemName: station.symbolName)
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(station.genre.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(station.tint)
                Text(station.name)
                    .font(.largeTitle.bold())
                Text("UKW \(station.frequency)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
    }

    private var statsGrid: some View {
        Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 8) {
            GridRow {
                Text("Hörer").foregroundStyle(.secondary)
                Text(station.listeners.formatted(.number.grouping(.automatic)))
                    .monospacedDigit()
            }
            GridRow {
                Text("Genre").foregroundStyle(.secondary)
                Text(station.genre.rawValue)
            }
            GridRow {
                Text("Frequenz").foregroundStyle(.secondary)
                Text("\(station.frequency) MHz").monospacedDigit()
            }
        }
        .font(.callout)
    }
}

/// The edge the system would use for a vertical bar, or `nil` where it never
/// places one. Read-only — it reflects locale and device.
@available(iOS 27.1, *)
private struct VerticalEdgeReadout: View {
    @Environment(\.toolbarVerticalEdge) private var verticalEdge

    var body: some View {
        LabeledContent("Bevorzugte Kante", value: edgeDescription)
    }

    private var edgeDescription: String {
        // `toolbarVerticalEdge` is an optional `HorizontalEdge`; unwrap it
        // rather than switching, so the optional case stays explicit.
        guard let verticalEdge else {
            return "keine — das System legt hier keine vertikale Leiste an"
        }
        return verticalEdge == .leading ? "führend" : "nachlaufend"
    }
}

#Preview {
    NavigationStack {
        StationDetailScreen(
            station: SampleData.stations[0],
            isFavorite: true,
            onToggleFavorite: {}
        )
    }
    .environment(PlayerModel())
}
