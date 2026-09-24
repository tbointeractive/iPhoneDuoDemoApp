import SwiftUI

/// A podcast series with a handful of episodes.
struct Podcast: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let host: String
    let symbolName: String
    let tint: Color
    let episodes: [Episode]
}

/// A single podcast episode.
struct Episode: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let summary: String
    let duration: Duration
    let publishedAt: Date
}
