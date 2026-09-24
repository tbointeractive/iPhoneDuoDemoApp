import Foundation
import Observation

/// Drives the mini player. Playback is simulated — the progress ticks on a task,
/// nothing is decoded or streamed.
@MainActor
@Observable
final class PlayerModel {
    private(set) var station: Station?
    private(set) var isPlaying = false
    private(set) var elapsed: Duration = .zero

    /// Title of the fictional track currently on air.
    private(set) var trackTitle = "Keine Wiedergabe"

    /// Length of the fictional track, used to normalize `progress`.
    let trackLength: Duration = .seconds(214)

    var progress: Double {
        let total = Double(trackLength.components.seconds)
        guard total > 0 else { return 0 }
        return min(Double(elapsed.components.seconds) / total, 1)
    }

    private var ticker: Task<Void, Never>?

    func play(_ station: Station) {
        if self.station?.id != station.id {
            self.station = station
            elapsed = .zero
            trackTitle = Self.trackTitle(for: station)
        }
        resume()
    }

    func togglePlayPause() {
        guard station != nil else { return }
        if isPlaying { pause() } else { resume() }
    }

    func skipForward() {
        elapsed = min(elapsed + .seconds(15), trackLength)
    }

    func skipBackward() {
        elapsed = max(elapsed - .seconds(15), .zero)
    }

    private func resume() {
        guard !isPlaying else { return }
        isPlaying = true
        ticker?.cancel()
        ticker = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard let self, self.isPlaying else { return }
                self.advanceOneSecond()
            }
        }
    }

    private func pause() {
        isPlaying = false
        ticker?.cancel()
        ticker = nil
    }

    private func advanceOneSecond() {
        if elapsed >= trackLength {
            elapsed = .zero
        } else {
            elapsed = elapsed + .seconds(1)
        }
    }

    private static func trackTitle(for station: Station) -> String {
        switch station.genre {
        case .electronic: "Nordlicht — Ausklang (Extended Mix)"
        case .rock: "Halle 9 — Zwischen den Verstärkern"
        case .pop: "Mira Vogt — Sommer auf Abruf"
        case .talk: "Gespräch: Warum Geräte sich falten"
        case .classical: "Streichquartett Nr. 4, 2. Satz"
        }
    }
}
