import SwiftUI

/// Episode list for one podcast, pushed onto the stack.
struct PodcastDetailScreen: View {
    let podcast: Podcast

    var body: some View {
        List {
            Section {
                ForEach(podcast.episodes) { episode in
                    NavigationLink(value: episode) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(episode.title)
                            Text(episode.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            Text("\(episode.duration.formatted(.units(allowed: [.hours, .minutes], width: .narrow))) · \(episode.publishedAt.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 2)
                    }
                }
            } header: {
                Text("Folgen")
            } footer: {
                Text("Moderation: \(podcast.host)")
            }
        }
        .navigationTitle(podcast.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PodcastDetailScreen(podcast: SampleData.podcasts[0])
    }
}
