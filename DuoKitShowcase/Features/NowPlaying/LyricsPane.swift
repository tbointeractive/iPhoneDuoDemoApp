import SwiftUI

/// Secondary content of the split arrangement.
struct LyricsPane: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Text")
                    .font(.title3.bold())
                    .padding(.bottom, 4)

                ForEach(Array(SampleData.lyricLines.enumerated()), id: \.offset) { _, line in
                    if line.isEmpty {
                        Spacer(minLength: 12)
                    } else {
                        Text(line)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    LyricsPane()
}
