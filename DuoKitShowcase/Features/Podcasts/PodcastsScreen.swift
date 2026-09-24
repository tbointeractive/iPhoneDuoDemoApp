import SwiftUI

/// The counterpart to the split view: a plain push stack.
///
/// Worth showing next to `StationsScreen` because a `NavigationStack` keeps
/// pushing on the inner display too — it does not grow a second column. If a
/// screen should use the extra width, that is a decision to make, not something
/// the stack does on its own.
struct PodcastsScreen: View {
    @State private var path = NavigationPath()
    @State private var searchText = ""

    var body: some View {
        NavigationStack(path: $path) {
            List(filteredPodcasts) { podcast in
                NavigationLink(value: podcast) {
                    PodcastRow(podcast: podcast)
                }
            }
            .navigationTitle("Podcasts")
            .searchable(text: $searchText, prompt: "Titel oder Host")
            .navigationDestination(for: Podcast.self) { podcast in
                PodcastDetailScreen(podcast: podcast)
            }
            .navigationDestination(for: Episode.self) { episode in
                EpisodeDetailScreen(episode: episode)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Zum Anfang", systemImage: "arrow.uturn.backward") {
                        path = NavigationPath()
                    }
                    .disabled(path.isEmpty)
                }
            }
        }
    }

    private var filteredPodcasts: [Podcast] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return SampleData.podcasts }
        return SampleData.podcasts.filter {
            $0.title.localizedStandardContains(query) || $0.host.localizedStandardContains(query)
        }
    }
}

/// One row in the podcast list.
struct PodcastRow: View {
    let podcast: Podcast

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(podcast.tint.gradient)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: podcast.symbolName)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(podcast.title)
                Text("\(podcast.host) · \(podcast.episodes.count) Folgen")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    PodcastsScreen()
}
