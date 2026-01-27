import SwiftUI
import RealityKit
import ARKit

/// Wraps RealityKit's `ARView` for use inside SwiftUI.
///
/// This type uses a coordinator to connect touch input back to simple AR logic.
struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject private var appState: AppState

    func makeCoordinator() -> Coordinator {
        Coordinator(appState: appState)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Create and store the session manager.
        let manager = ARSessionManager(arView: arView, appState: appState)
        context.coordinator.sessionManager = manager
        manager.configureSession()

        // Add a simple tap recognizer to place objects.
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // React to reset flag from the SwiftUI side.
        if appState.resetSceneToggle {
            context.coordinator.sessionManager?.resetScene()
            appState.resetSceneToggle = false
        }
    }

    // MARK: - Coordinator

    class Coordinator: NSObject {
        let appState: AppState
        fileprivate var sessionManager: ARSessionManager?

        init(appState: AppState) {
            self.appState = appState
        }

        /// Called when the user taps inside the ARView.
        @objc
        func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let view = recognizer.view as? ARView else { return }
            let location = recognizer.location(in: view)
            sessionManager?.handleTap(at: location)
        }
    }
}

