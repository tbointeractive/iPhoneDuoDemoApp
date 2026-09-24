import SwiftUI

/// Master–detail over the station list.
///
/// `NavigationSplitView` is the whole adaptation story here: on the outer
/// display it collapses to a stack and pushes the detail, on the inner display
/// it shows both columns side by side. No size class is read in this file.
struct StationsScreen: View {
    @Environment(PlayerModel.self) private var player
    @Environment(DiagnosticsModel.self) private var diagnostics

    @State private var selectedStationID: Station.ID?
    @State private var sortOrder: StationSort = .name
    @State private var showsFavoritesOnly = false
    @State private var favorites: Set<Station.ID> = []

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedStationID) {
                Section {
                    ForEach(visibleStations) { station in
                        StationRow(station: station, isFavorite: favorites.contains(station.id))
                            .tag(station.id)
                    }
                } header: {
                    Text("\(visibleStations.count) von \(SampleData.stations.count)")
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Sender")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sortierung", selection: $sortOrder) {
                            ForEach(StationSort.allCases, id: \.self) { order in
                                Text(order.label).tag(order)
                            }
                        }
                    } label: {
                        Label("Sortieren", systemImage: "arrow.up.arrow.down")
                    }

                    Toggle(isOn: $showsFavoritesOnly) {
                        Label("Nur Favoriten", systemImage: "star")
                    }
                }
                // Keeps sorting and filtering in the bar when the bar runs out
                // of room; lower-priority items move into the overflow first.
                .visibilityPriority(.high)

                // Pinned: never moves into the overflow menu, however tight it gets.
                ToolbarItem(placement: .topBarPinnedTrailing) {
                    Button("Diagnose", systemImage: "ruler") {
                        diagnostics.isOverlayVisible.toggle()
                    }
                }

                // Always in the overflow menu, never in the bar itself.
                ToolbarOverflowMenu {
                    Button("Auswahl aufheben", systemImage: "xmark.circle") {
                        selectedStationID = nil
                    }
                    Button("Favoriten leeren", systemImage: "star.slash") {
                        favorites.removeAll()
                    }
                }
            }
        } detail: {
            if let station = selectedStation {
                StationDetailScreen(
                    station: station,
                    isFavorite: favorites.contains(station.id),
                    onToggleFavorite: { toggleFavorite(station.id) }
                )
            } else {
                ContentUnavailableView(
                    "Kein Sender gewählt",
                    systemImage: "dot.radiowaves.left.and.right",
                    description: Text("Links einen Sender wählen. Aufgeklappt stehen Liste und Detail nebeneinander.")
                )
            }
        }
    }

    private var visibleStations: [Station] {
        let base = showsFavoritesOnly
            ? SampleData.stations.filter { favorites.contains($0.id) }
            : SampleData.stations
        return base.sorted(by: sortOrder.comparator)
    }

    private var selectedStation: Station? {
        guard let selectedStationID else { return nil }
        return SampleData.stations.first { $0.id == selectedStationID }
    }

    private func toggleFavorite(_ id: Station.ID) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
    }
}

/// Sort orders offered in the list toolbar.
enum StationSort: CaseIterable, Hashable {
    case name
    case listeners
    case frequency

    var label: String {
        switch self {
        case .name: "Name"
        case .listeners: "Hörerzahl"
        case .frequency: "Frequenz"
        }
    }

    var comparator: (Station, Station) -> Bool {
        switch self {
        case .name:
            return { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        case .listeners:
            return { $0.listeners > $1.listeners }
        case .frequency:
            return { $0.frequency.localizedStandardCompare($1.frequency) == .orderedAscending }
        }
    }
}

#Preview {
    StationsScreen()
        .environment(PlayerModel())
        .environment(DiagnosticsModel())
}
