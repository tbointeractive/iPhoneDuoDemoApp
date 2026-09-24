import SwiftUI

/// Third level of the push stack — deliberately deep, so the back chain is
/// visible when the device is folded and unfolded mid-navigation.
struct EpisodeDetailScreen: View {
    let episode: Episode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(episode.title)
                    .font(.title2.bold())

                Text(episode.publishedAt.formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(episode.summary)

                Divider()

                Text(String(repeating: SampleData.lyricLines.joined(separator: " "), count: 4))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Folge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EpisodeDetailScreen(episode: SampleData.podcasts[0].episodes[0])
    }
}
