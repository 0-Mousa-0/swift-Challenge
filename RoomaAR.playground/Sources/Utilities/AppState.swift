import SwiftUI

/// Shared app-wide state for the RoomaAR experience.
final class AppState: ObservableObject {
    /// Intro flow state.
    @Published var showIntro = true

    /// Current furniture selection.
    @Published var selectedFurniture: FurnitureItem? = FurnitureItem.defaultItems.first

    /// Contextual helper text shown to users.
    @Published var statusMessage = "Move your iPad slowly to scan a floor or table surface."

    /// Trigger used by SwiftUI to request a full AR scene reset.
    @Published var resetSceneToggle = false

    /// Number of objects currently placed.
    @Published var placementsCount = 0

    func didPlaceItem(named name: String) {
        placementsCount += 1
        statusMessage = "Placed \(name). Use two fingers to move, rotate, and scale."
    }
}
