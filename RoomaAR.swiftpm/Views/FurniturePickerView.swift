import SwiftUI

/// Horizontal picker shown on top of the AR view to choose furniture models.
struct FurniturePickerView: View {
    @EnvironmentObject private var appState: AppState

    private let items = FurnitureItem.defaultItems

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items) { item in
                    FurniturePickerButton(
                        item: item,
                        isSelected: item == appState.selectedFurniture
                    )
                    .onTapGesture {
                        appState.selectedFurniture = item
                        appState.statusMessage = "Tap on a detected surface to place the \(item.name.lowercased())."
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}

/// Individual pill-shaped button in the picker.
private struct FurniturePickerButton: View {
    let item: FurnitureItem
    let isSelected: Bool

    var body: some View {
        Text(item.name)
            .font(.subheadline.bold())
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? Color.blue : Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            )
    }
}

struct FurniturePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.4).ignoresSafeArea()
            FurniturePickerView()
                .environmentObject(AppState())
                .padding()
        }
    }
}

