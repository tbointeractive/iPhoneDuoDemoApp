import SwiftUI

/// A radio station shown in the master list and on the detail screen.
struct Station: Identifiable, Hashable, Sendable {
    enum Genre: String, CaseIterable, Sendable {
        case electronic = "Electronic"
        case rock = "Rock"
        case pop = "Pop"
        case talk = "Wort"
        case classical = "Klassik"
    }

    let id: UUID
    let name: String
    let tagline: String
    let genre: Genre
    let frequency: String
    let listeners: Int
    let symbolName: String
    let tint: Color
    let description: String
}
