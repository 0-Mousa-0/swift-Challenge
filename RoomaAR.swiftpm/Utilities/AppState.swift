import Foundation
import SwiftUI

/// Shared observable state for the whole app.
final class AppState: ObservableObject {
    /// Whether to show the intro screen or jump straight into AR.
    @Published var showIntro: Bool = true

    /// Currently selected furniture from the picker.
    @Published var selectedFurniture: FurnitureItem? = FurnitureItem.defaultItems.first

    /// Text shown at the bottom of the AR screen to guide the user.
    @Published var statusMessage: String = "Move your iPad to detect a horizontal surface."

    /// Used to trigger a reset of all placed objects.
    @Published var resetSceneToggle: Bool = false
}

