import SwiftUI

/// One row in the station list.
struct StationRow: View {
    let station: Station
    let isFavorite: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: station.symbolName)
                .font(.title3)
                .foregroundStyle(station.tint)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(station.name)
                    .font(.body)
                Text(station.tagline)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            if isFavorite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }

            Text(station.frequency)
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}
