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
    /// Primary model resource path expected in the app bundle.
    let modelFileName: String
    /// Optional fallback paths to support legacy location and custom import flows.
    let alternateModelFileNames: [String]
    let fallbackShape: FallbackShape
    let tint: UIColor
    let preferredScale: Float
    /// Source model page on CGTrader.
    let cgtraderPageURL: String
    /// Download hub page for the model on CGTrader.
    let cgtraderDownloadPageURL: String

    var modelResourceCandidates: [String] {
        [modelFileName] + alternateModelFileNames
    }

    var cacheKey: String {
        name.lowercased()
    }
}

extension FurnitureItem {
    static let defaultItems: [FurnitureItem] = [
        FurnitureItem(
            name: "Sofa",
            modelFileName: "Models/sofa.usdz",
            alternateModelFileNames: ["sofa.usdz"],
            fallbackShape: .box,
            tint: UIColor(red: 0.89, green: 0.59, blue: 0.40, alpha: 1.0),
            preferredScale: 0.45,
            cgtraderPageURL: "https://www.cgtrader.com/free-3d-models/furniture/sofa/loveseats-sofa",
            cgtraderDownloadPageURL: "https://www.cgtrader.com/items/3660386/download-page"
        ),
        FurnitureItem(
            name: "Table",
            modelFileName: "Models/table.usdz",
            alternateModelFileNames: ["table.usdz"],
            fallbackShape: .cylinder,
            tint: UIColor(red: 0.40, green: 0.60, blue: 0.44, alpha: 1.0),
            preferredScale: 0.35,
            cgtraderPageURL: "https://www.cgtrader.com/free-3d-models/furniture/table/cc0-table",
            cgtraderDownloadPageURL: "https://www.cgtrader.com/items/3531094/download-page"
        ),
        FurnitureItem(
            name: "Chair",
            modelFileName: "Models/chair.usdz",
            alternateModelFileNames: ["chair.usdz"],
            fallbackShape: .box,
            tint: UIColor(red: 0.43, green: 0.56, blue: 0.86, alpha: 1.0),
            preferredScale: 0.28,
            cgtraderPageURL: "https://www.cgtrader.com/free-3d-models/furniture/chair/wooden-chair-with-curve-handle-golden-legs",
            cgtraderDownloadPageURL: "https://www.cgtrader.com/items/5354494/download-page"
        ),
        FurnitureItem(
            name: "Curtain",
            modelFileName: "Models/curtain.usdz",
            alternateModelFileNames: ["curtain.usdz"],
            fallbackShape: .plane,
            tint: UIColor(red: 0.88, green: 0.70, blue: 0.90, alpha: 1.0),
            preferredScale: 0.75,
            cgtraderPageURL: "https://www.cgtrader.com/free-3d-models/furniture/other/simple-curtain-657b8a8d-b07b-4380-ab86-731fd2861e09",
            cgtraderDownloadPageURL: "https://www.cgtrader.com/items/4159526/download-page"
        ),
        FurnitureItem(
            name: "Carpet",
            modelFileName: "Models/carpet.usdz",
            alternateModelFileNames: ["carpet.usdz"],
            fallbackShape: .plane,
            tint: UIColor(red: 0.82, green: 0.44, blue: 0.45, alpha: 1.0),
            preferredScale: 0.60,
            cgtraderPageURL: "https://www.cgtrader.com/free-3d-models/household/other/carpets-43a69c8a-7235-4c6d-aa4c-68789464cdd6",
            cgtraderDownloadPageURL: "https://www.cgtrader.com/items/1927737/download-page"
        )
    ]
}
