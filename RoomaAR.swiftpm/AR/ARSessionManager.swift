import Foundation
import ARKit
import RealityKit

/// Manages the AR session configuration and simple interactions.
///
/// This class keeps AR-specific logic away from SwiftUI views.
final class ARSessionManager: NSObject {
    let arView: ARView
    private let appState: AppState

    init(arView: ARView, appState: AppState) {
        self.arView = arView
        self.appState = appState
        super.init()
    }

    /// Configure plane detection and basic ARView options.
    func configureSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        arView.automaticallyConfigureSession = false
        arView.debugOptions = []
    }

    /// Remove all anchors and restart guidance message.
    func resetScene() {
        arView.scene.anchors.removeAll()
        configureSession()
        appState.statusMessage = "Scene cleared. Move your iPad to detect a surface."
    }

    /// Handle a user tap in the ARView by raycasting and placing the selected furniture.
    func handleTap(at location: CGPoint) {
        guard let selected = appState.selectedFurniture else {
            appState.statusMessage = "Pick a furniture item first."
            return
        }

        // Perform a raycast from the screen point into the real world.
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)

        guard let firstResult = results.first else {
            appState.statusMessage = "No surface found. Try moving the iPad slowly."
            return
        }

        placeFurniture(named: selected.modelFileName, at: firstResult)
    }

    /// Load a `.usdz` model from the app bundle and place it at the raycast result.
    private func placeFurniture(named fileName: String, at raycastResult: ARRaycastResult) {
        do {
            // `ModelEntity.loadModel` is async-capable, but here we keep it simple / synchronous.
            let entity = try ModelEntity.loadModel(named: fileName)

            // Add some default collision and interaction so gestures work well.
            entity.generateCollisionShapes(recursive: true)
            arView.installGestures([.translation, .rotation, .scale], for: entity)

            let anchor = AnchorEntity(world: raycastResult.worldTransform)
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)

            appState.statusMessage = "Placed \(fileName). Use two fingers to move, rotate, or scale."
        } catch {
            appState.statusMessage = "Could not load model: \(fileName). Make sure the .usdz file is in the bundle."
            print("Error loading model \(fileName): \(error)")
        }
    }
}

