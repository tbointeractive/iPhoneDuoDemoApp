import Observation
import SwiftUI

/// Holds the pieces of debug state that outlive a single view.
///
/// Geometry is deliberately *not* stored here. Sizes, safe areas and reserved
/// regions are read straight from a `GeometryProxy` where they are displayed,
/// so the overlay always shows what SwiftUI resolved in this layout pass —
/// and no state is mutated while the view tree is being built.
@MainActor
@Observable
final class DiagnosticsModel {
    /// Whether the floating metrics panel is shown.
    var isOverlayVisible = false

    /// Last hinge state reported by `onHingeChange(isEnabled:_:)`.
    ///
    /// Stays `nil` on hardware without a hinge — every iPhone that is not an
    /// iPhone Duo, the simulator unless a foldable device is selected, and any
    /// device below iOS 27.1, where the API does not exist at all.
    var hinge: HingeSnapshot?

    var hingeAngleDescription: String {
        guard let hinge else { return "—" }
        return hinge.degrees.formatted(.number.precision(.fractionLength(0))) + "°"
    }

    var hingeStatusDescription: String {
        hinge?.statusDescription ?? "kein Scharnier"
    }
}
