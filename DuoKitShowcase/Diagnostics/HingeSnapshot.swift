import SwiftUI

/// Version-agnostic copy of the hinge state.
///
/// `DeviceHinge` exists only from iOS 27.1, so the model and the screens hold
/// this instead and stay free of availability annotations.
struct HingeSnapshot: Equatable {
    let degrees: Double
    let statusDescription: String
}

extension HingeSnapshot {
    /// Takes an optional so it compiles whether or not the context's hinge is one.
    @available(iOS 27.1, *)
    init?(_ hinge: DeviceHinge?) {
        guard let hinge else { return nil }
        self.init(
            degrees: hinge.angle.degrees,
            statusDescription: Self.description(for: hinge.status)
        )
    }

    /// `DeviceHinge.Status` is a struct with static members rather than an enum,
    /// so it is compared rather than switched over exhaustively.
    @available(iOS 27.1, *)
    private static func description(for status: DeviceHinge.Status) -> String {
        if status == .closed { return "geschlossen" }
        if status == .partiallyOpen { return "teilweise offen" }
        if status == .fullyOpen { return "ganz offen" }
        return "unbekannt"
    }
}
