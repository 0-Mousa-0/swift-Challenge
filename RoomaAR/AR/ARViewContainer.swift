#if !targetEnvironment(simulator)
import SwiftUI
import RealityKit
import ARKit

/// SwiftUI wrapper around RealityKit's ARView.
struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject private var appState: AppState

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let manager = ARSessionManager(arView: arView, appState: appState)
        context.coordinator.sessionManager = manager
        manager.configureSession()

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)

        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.delegate = context.coordinator
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlay)

        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if appState.resetSceneToggle {
            context.coordinator.sessionManager?.resetScene()
            DispatchQueue.main.async {
                appState.resetSceneToggle = false
            }
        }

        if let selected = appState.selectedFurniture,
           context.coordinator.lastPreloadedModelName != selected.cacheKey {
            context.coordinator.lastPreloadedModelName = selected.cacheKey
            context.coordinator.sessionManager?.preloadModel(for: selected)
        }
    }

    final class Coordinator: NSObject, ARCoachingOverlayViewDelegate {
        var sessionManager: ARSessionManager?
        var lastPreloadedModelName: String?

        @objc
        func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let arView = recognizer.view as? ARView else { return }
            let location = recognizer.location(in: arView)
            sessionManager?.handleTap(at: location)
        }
    }
}
#endif
