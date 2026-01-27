import Foundation

/// Simple model describing a furniture item that can be placed in AR.
struct FurnitureItem: Identifiable, Hashable {
    let id = UUID()
    /// Display name, e.g. "Sofa"
    let name: String
    /// The name of the local `.usdz` file in the bundle, e.g. "sofa.usdz"
    let modelFileName: String
}

extension FurnitureItem {
    /// Default library of furniture used by the picker.
    static let defaultItems: [FurnitureItem] = [
        FurnitureItem(name: "Sofa",   modelFileName: "sofa.usdz"),
        FurnitureItem(name: "Table",  modelFileName: "table.usdz"),
        FurnitureItem(name: "Chair",  modelFileName: "chair.usdz"),
        FurnitureItem(name: "Curtain", modelFileName: "curtain.usdz"),
        FurnitureItem(name: "Carpet", modelFileName: "carpet.usdz")
    ]
}

