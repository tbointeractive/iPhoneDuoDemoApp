import Foundation
import SwiftUI

/// Static demo content. Nothing here talks to a network; the app is a UI sandbox.
enum SampleData {
    static let stations: [Station] = [
        Station(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000A1")!,
            name: "Sunrise FM",
            tagline: "Wach werden mit Bass",
            genre: .electronic,
            frequency: "101.3",
            listeners: 48_200,
            symbolName: "sunrise.fill",
            tint: .orange,
            description: """
            Der Morgenkanal mit langen Sets und kurzen Wortbeiträgen. \
            Läuft durchgehend, moderiert wird nur zur vollen Stunde.
            """
        ),
        Station(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000A2")!,
            name: "Nachtschicht",
            tagline: "Von 22 Uhr bis zum Morgengrauen",
            genre: .electronic,
            frequency: "94.7",
            listeners: 12_940,
            symbolName: "moon.stars.fill",
            tint: .indigo,
            description: """
            Deep House, Ambient und Downtempo für alle, die noch am Rechner sitzen. \
            Keine Werbung zwischen Mitternacht und sechs.
            """
        ),
        Station(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000A3")!,
            name: "Gitarrenwerk",
            tagline: "Laut, verzerrt, ehrlich",
            genre: .rock,
            frequency: "88.1",
            listeners: 31_570,
            symbolName: "guitars.fill",
            tint: .red,
            description: """
            Klassischer Rock mit einem Schwerpunkt auf Livemitschnitten. \
            Jeden Donnerstag eine komplette Konzertaufnahme am Stück.
            """
        ),
        Station(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000A4")!,
            name: "Hitliste",
            tagline: "Die Top 40, ohne Umweg",
            genre: .pop,
            frequency: "105.9",
            listeners: 96_310,
            symbolName: "chart.bar.fill",
            tint: .pink,
            description: """
            Rotation aus den aktuellen Charts, dazu stündlich Nachrichten. \
            Der Kanal mit der höchsten Reichweite im Testdatensatz.
            """
        ),
        Station(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000A5")!,
            name: "Langformat",
            tagline: "Gespräche, die Zeit brauchen",
            genre: .talk,
            frequency: "97.2",
            listeners: 8_410,
            symbolName: "mic.fill",
            tint: .teal,
            description: """
            Interviews ohne Sendeschluss, Reportagen und Lesungen. \
            Der ruhigste Kanal im Angebot — und der beste Test für lange Detailtexte.
            """
        ),
        Station(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000A6")!,
            name: "Kammerton",
            tagline: "Konzert und Kammermusik",
            genre: .classical,
            frequency: "92.4",
            listeners: 15_880,
            symbolName: "pianokeys",
            tint: .brown,
            description: """
            Aufnahmen aus europäischen Konzerthäusern, dazwischen kurze Einordnungen. \
            Abends ganze Sinfonien ohne Unterbrechung.
            """
        )
    ]

    static let podcasts: [Podcast] = [
        Podcast(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000B1")!,
            title: "Faltbar",
            host: "Redaktion Technik",
            symbolName: "book.pages.fill",
            tint: .blue,
            episodes: [
                Episode(
                    id: UUID(uuidString: "00000000-0000-0000-0000-0000000000C1")!,
                    title: "Ein Scharnier, zwei Displays",
                    summary: "Was sich im Layout ändert, wenn ein Gerät in der Mitte aufgeht.",
                    duration: .seconds(2_940),
                    publishedAt: Date(timeIntervalSince1970: 1_757_376_000)
                ),
                Episode(
                    id: UUID(uuidString: "00000000-0000-0000-0000-0000000000C2")!,
                    title: "Size Classes statt Gerätenamen",
                    summary: "Warum die Abfrage nach dem Modell fast immer die falsche Frage ist.",
                    duration: .seconds(2_130),
                    publishedAt: Date(timeIntervalSince1970: 1_756_771_200)
                ),
                Episode(
                    id: UUID(uuidString: "00000000-0000-0000-0000-0000000000C3")!,
                    title: "Zustand über den Faltvorgang retten",
                    summary: "Was beim Wechsel zwischen Außen- und Innendisplay passiert.",
                    duration: .seconds(3_360),
                    publishedAt: Date(timeIntervalSince1970: 1_756_166_400)
                )
            ]
        ),
        Podcast(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000B2")!,
            title: "Nachtschicht Talk",
            host: "Jana & Kim",
            symbolName: "waveform.circle.fill",
            tint: .indigo,
            episodes: [
                Episode(
                    id: UUID(uuidString: "00000000-0000-0000-0000-0000000000C4")!,
                    title: "Warum wir nachts arbeiten",
                    summary: "Zwei Stunden über Schichtpläne, Kaffee und Kopfhörer.",
                    duration: .seconds(7_200),
                    publishedAt: Date(timeIntervalSince1970: 1_757_030_400)
                ),
                Episode(
                    id: UUID(uuidString: "00000000-0000-0000-0000-0000000000C5")!,
                    title: "Die Playlist der Woche",
                    summary: "Sechs Tracks, die es diese Woche in die Rotation geschafft haben.",
                    duration: .seconds(1_800),
                    publishedAt: Date(timeIntervalSince1970: 1_756_425_600)
                )
            ]
        ),
        Podcast(
            id: UUID(uuidString: "00000000-0000-0000-0000-0000000000B3")!,
            title: "Kurzschluss",
            host: "Ali Osmani",
            symbolName: "bolt.horizontal.circle.fill",
            tint: .yellow,
            episodes: [
                Episode(
                    id: UUID(uuidString: "00000000-0000-0000-0000-0000000000C6")!,
                    title: "Zehn Minuten über Toolbars",
                    summary: "Was in die Leiste gehört und was ins Überlaufmenü.",
                    duration: .seconds(600),
                    publishedAt: Date(timeIntervalSince1970: 1_757_203_200)
                )
            ]
        )
    ]

    /// Fake lyrics used by the split arrangement demo.
    static let lyricLines: [String] = [
        "Zwei Bildschirme, ein Gerät",
        "die Mitte trägt die Naht",
        "was zugeklappt noch Liste war",
        "liegt offen als Detail",
        "",
        "Kein Modellname im Code",
        "nur Größenklassen zählen",
        "das Scharnier misst einen Winkel",
        "den Rest macht das Layout",
        "",
        "Dreh es, klapp es, leg es hin",
        "der Zustand bleibt bestehen",
        "und über der Leiste unten",
        "läuft der Player weiter"
    ]
}
