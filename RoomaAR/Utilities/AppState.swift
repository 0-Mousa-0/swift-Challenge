import SwiftUI

/// Shared app-wide state for the RoomaAR experience.
final class AppState: ObservableObject {
    @Published var showIntro = true
    @Published var selectedFurniture: FurnitureItem? = FurnitureItem.defaultItems.first
    @Published var statusMessage = "Move your device slowly to scan surfaces."
    @Published var resetSceneToggle = false
    @Published var placementsCount = 0

    func didPlaceItem(named name: String) {
        placementsCount += 1
        statusMessage = "Placed \(name). Move, rotate, or scale with gestures."
    }
}
