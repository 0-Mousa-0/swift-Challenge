import SwiftUI

/// Simulator fallback surface so interaction can be tested without AR camera support.
struct SimulatorRoomView: View {
    @EnvironmentObject private var appState: AppState
    @State private var placements: [SimulatorPlacement] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [Color.black.opacity(0.92), Color.gray.opacity(0.70)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                gridOverlay

                ForEach(placements) { placement in
                    placementCard(for: placement)
                        .position(
                            x: placement.normalizedPosition.x * geometry.size.width,
                            y: placement.normalizedPosition.y * geometry.size.height
                        )
                }

                VStack {
                    Text("SIMULATOR MODE")
                        .font(.caption.bold())
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.50))
                        .clipShape(Capsule())
                        .padding(.top, 40)

                    Spacer()
                }
            }
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        placeSelectedFurniture(at: value.location, in: geometry.size)
                    }
            )
        }
        .onAppear {
            appState.statusMessage = "Simulator mode: tap anywhere to place selected furniture."
        }
        .onChange(of: appState.selectedFurniture) { _, selected in
            if let selected {
                appState.statusMessage = "Simulator mode: tap anywhere to place \(selected.name)."
            }
        }
        .onChange(of: appState.resetSceneToggle) { _, shouldReset in
            guard shouldReset else { return }
            placements.removeAll()
            appState.placementsCount = 0
            appState.statusMessage = "Simulator scene reset."
            appState.resetSceneToggle = false
        }
    }

    private var gridOverlay: some View {
        GeometryReader { geometry in
            Path { path in
                let step: CGFloat = 36
                let width = geometry.size.width
                let height = geometry.size.height

                var x: CGFloat = 0
                while x <= width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: height))
                    x += step
                }

                var y: CGFloat = 0
                while y <= height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                    y += step
                }
            }
            .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
        }
    }

    private func placementCard(for placement: SimulatorPlacement) -> some View {
        let fill = Color(uiColor: placement.item.tint).opacity(0.92)
        let baseWidth: CGFloat = 120
        let baseHeight: CGFloat = placement.item.fallbackShape == .plane ? 34 : 70

        return RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(fill)
            .frame(width: baseWidth * placement.scale, height: baseHeight * placement.scale)
            .overlay(
                Text(placement.item.name)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(4)
            )
            .rotationEffect(placement.rotation)
            .shadow(color: .black.opacity(0.30), radius: 6, x: 0, y: 3)
    }

    private func placeSelectedFurniture(at location: CGPoint, in size: CGSize) {
        guard let selected = appState.selectedFurniture else {
            appState.statusMessage = "Pick furniture first."
            return
        }

        guard size.width > 0, size.height > 0 else { return }

        let normalizedX = max(0.03, min(0.97, location.x / size.width))
        let normalizedY = max(0.08, min(0.92, location.y / size.height))
        let rotation = Angle.degrees(Double.random(in: -12 ... 12))
        let scale = max(0.75, min(1.35, CGFloat(selected.preferredScale) * 2.4))

        placements.append(
            SimulatorPlacement(
                item: selected,
                normalizedPosition: CGPoint(x: normalizedX, y: normalizedY),
                rotation: rotation,
                scale: scale
            )
        )

        if placements.count > 45 {
            placements.removeFirst(placements.count - 45)
        }

        appState.didPlaceItem(named: selected.name)
    }
}

private struct SimulatorPlacement: Identifiable {
    let id = UUID()
    let item: FurnitureItem
    let normalizedPosition: CGPoint
    let rotation: Angle
    let scale: CGFloat
}
