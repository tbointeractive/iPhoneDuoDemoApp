import SwiftUI

/// The tab with the `search` role. On iPhone the search field takes the place
/// of the tab bar; once the tab bar becomes a sidebar, it moves up there.
struct SearchScreen: View {
    @State private var query = ""

    var body: some View {
        NavigationStack {
            List {
                if !stationHits.isEmpty {
                    Section("Sender") {
                        ForEach(stationHits) { station in
                            StationRow(station: station, isFavorite: false)
                        }
                    }
                }
                if !podcastHits.isEmpty {
                    Section("Podcasts") {
                        ForEach(podcastHits) { podcast in
                            PodcastRow(podcast: podcast)
                        }
                    }
                }
                if query.isEmpty {
                    ContentUnavailableView(
                        "Suche",
                        systemImage: "magnifyingglass",
                        description: Text("Nach Sendern und Podcasts suchen.")
                    )
                } else if stationHits.isEmpty && podcastHits.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
            .navigationTitle("Suche")
            .searchable(text: $query, prompt: "Sender, Podcast, Host")
        }
    }

    private var stationHits: [Station] {
        guard !query.isEmpty else { return [] }
        return SampleData.stations.filter {
            $0.name.localizedStandardContains(query) || $0.genre.rawValue.localizedStandardContains(query)
        }
    }

    private var podcastHits: [Podcast] {
        guard !query.isEmpty else { return [] }
        return SampleData.podcasts.filter {
            $0.title.localizedStandardContains(query) || $0.host.localizedStandardContains(query)
        }
    }
}

#Preview {
    SearchScreen()
}
