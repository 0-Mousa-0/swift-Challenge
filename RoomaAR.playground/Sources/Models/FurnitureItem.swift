import Foundation
import UIKit

/// Describes one placeable furniture type.
struct FurnitureItem: Identifiable, Hashable {
    enum FallbackShape: Hashable {
        case box
        case cylinder
        case sphere
        case plane
    }

    let id = UUID()
    let name: String
    let modelFileName: String
    let fallbackShape: FallbackShape
    let tint: UIColor
    let preferredScale: Float
}

extension FurnitureItem {
    /// Curated lightweight set aimed for consistent real-time AR performance.
    static let defaultItems: [FurnitureItem] = [
        FurnitureItem(
            name: "Sofa",
            modelFileName: "sofa.usdz",
            fallbackShape: .box,
            tint: UIColor(red: 0.89, green: 0.59, blue: 0.40, alpha: 1.0),
            preferredScale: 0.45
        ),
        FurnitureItem(
            name: "Table",
            modelFileName: "table.usdz",
            fallbackShape: .cylinder,
            tint: UIColor(red: 0.40, green: 0.60, blue: 0.44, alpha: 1.0),
            preferredScale: 0.35
        ),
        FurnitureItem(
            name: "Chair",
            modelFileName: "chair.usdz",
            fallbackShape: .box,
            tint: UIColor(red: 0.43, green: 0.56, blue: 0.86, alpha: 1.0),
            preferredScale: 0.28
        ),
        FurnitureItem(
            name: "Curtain",
            modelFileName: "curtain.usdz",
            fallbackShape: .plane,
            tint: UIColor(red: 0.88, green: 0.70, blue: 0.90, alpha: 1.0),
            preferredScale: 0.75
        ),
        FurnitureItem(
            name: "Carpet",
            modelFileName: "carpet.usdz",
            fallbackShape: .plane,
            tint: UIColor(red: 0.82, green: 0.44, blue: 0.45, alpha: 1.0),
            preferredScale: 0.60
        )
    ]
}
