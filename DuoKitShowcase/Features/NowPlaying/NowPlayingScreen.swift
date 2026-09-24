import SwiftUI

/// The iOS 27.1 arrangement views, side by side with a switch between them.
///
/// An `ArrangementView` decides for itself whether its two children stack,
/// sit next to each other or overlap — based on available size, size class and
/// hardware. Folding the device is what makes that decision change.
struct NowPlayingScreen: View {
    enum Demo: String, CaseIterable, Hashable {
        case split = "Split"
        case overlay = "Overlay"
    }

    @State private var demo: Demo = .split

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Wiedergabe")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("Arrangement", selection: $demo) {
                            ForEach(Demo.allCases, id: \.self) { demo in
                                Text(demo.rawValue).tag(demo)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if #available(iOS 27.1, *) {
            arrangement
        } else {
            staticFallback
        }
    }

    @available(iOS 27.1, *)
    @ViewBuilder
    private var arrangement: some View {
        switch demo {
        case .split:
            ArrangementView {
                NowPlayingPane()
                    // A hint, not a hard constraint: the arrangement keeps the
                    // primary at roughly this share of the available axis.
                    .splitArrangementLayoutRatio(0.45)
            } secondary: {
                LyricsPane()
            }
            // Allow the split on both axes — folded it goes one way, unfolded
            // the other. Pass a single axis to pin it.
            .arrangementViewStyle(.split.axes([.horizontal, .vertical]))

        case .overlay:
            ArrangementView {
                PlaybackControlsPane()
                    .overlayArrangementEdge(.trailing)
            } secondary: {
                StagePane()
            }
            // Layered while space is tight; the arrangement may move the two
            // apart into a side-by-side layout when the device opens up.
            .arrangementViewStyle(.overlay)
        }
    }

    /// Below iOS 27.1 the panes are placed by hand, so the screen still shows
    /// what the arrangement would otherwise be deciding.
    @ViewBuilder
    private var staticFallback: some View {
        switch demo {
        case .split:
            VStack(spacing: 0) {
                NowPlayingPane()
                LyricsPane()
            }
        case .overlay:
            ZStack(alignment: .bottom) {
                StagePane()
                PlaybackControlsPane()
            }
        }
    }
}

#Preview {
    NowPlayingScreen()
        .environment(PlayerModel())
}
