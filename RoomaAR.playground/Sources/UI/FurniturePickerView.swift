import SwiftUI

/// Bottom horizontal picker for furniture categories.
struct FurniturePickerView: View {
    @EnvironmentObject private var appState: AppState

    private let items = FurnitureItem.defaultItems

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items) { item in
                    PickerChip(
                        item: item,
                        isSelected: item == appState.selectedFurniture
                    )
                    .onTapGesture {
                        appState.selectedFurniture = item
                        appState.statusMessage = "Selected \(item.name). Tap a detected surface to place it."
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}

private struct PickerChip: View {
    let item: FurnitureItem
    let isSelected: Bool

    var body: some View {
        Text(item.name)
            .font(.subheadline.bold())
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? Color.blue.opacity(0.92) : Color(.systemBackground).opacity(0.95))
                    .shadow(color: Color.black.opacity(isSelected ? 0.22 : 0.12), radius: 4, x: 0, y: 2)
            )
    }
}
