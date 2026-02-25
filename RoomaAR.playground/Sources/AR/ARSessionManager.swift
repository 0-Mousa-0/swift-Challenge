import Foundation
import ARKit
import RealityKit
import UIKit

/// Handles AR configuration, raycasting, placement, and model caching.
final class ARSessionManager: NSObject {
    let arView: ARView
    private let appState: AppState

    private var modelCache: [String: ModelEntity] = [:]
    private let cacheLock = NSLock()

    private var placedAnchors: [AnchorEntity] = []
    private let maxPlacedAnchors = 20

    init(arView: ARView, appState: AppState) {
        self.arView = arView
        self.appState = appState
        super.init()
    }

    func configureSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic

        arView.automaticallyConfigureSession = false
        arView.renderOptions.insert(.disableDepthOfField)
        arView.renderOptions.insert(.disableMotionBlur)
        arView.session.delegate = self
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        preloadDefaultModels()
    }

    func preloadModel(for item: FurnitureItem) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            _ = self?.loadModelPrototype(for: item)
        }
    }

    func resetScene() {
        arView.scene.anchors.removeAll()
        placedAnchors.removeAll()
        configureSession()
        DispatchQueue.main.async { [weak self] in
            self?.appState.statusMessage = "Scene reset. Move your iPad slowly to scan surfaces."
            self?.appState.placementsCount = 0
        }
    }

    func handleTap(at location: CGPoint) {
        guard let selected = appState.selectedFurniture else {
            appState.statusMessage = "Pick a furniture item first."
            return
        }

        let precise = arView.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal)
        let estimated = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)

        guard let raycastResult = precise.first ?? estimated.first else {
            appState.statusMessage = "No surface found yet. Move your iPad slowly and try again."
            return
        }

        placeFurniture(selected, at: raycastResult)
    }

    private func preloadDefaultModels() {
        FurnitureItem.defaultItems.forEach(preloadModel(for:))
    }

    private func placeFurniture(_ item: FurnitureItem, at raycastResult: ARRaycastResult) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }

            let prototype = self.loadModelPrototype(for: item)
            let instance = prototype.clone(recursive: true)
            instance.transform.scale = SIMD3<Float>(repeating: item.preferredScale)

            DispatchQueue.main.async {
                let anchor = AnchorEntity(world: raycastResult.worldTransform)
                anchor.addChild(instance)
                self.arView.scene.addAnchor(anchor)
                self.arView.installGestures([.translation, .rotation, .scale], for: instance)

                self.placedAnchors.append(anchor)
                self.trimPlacedAnchorsIfNeeded()
                self.appState.didPlaceItem(named: item.name)
            }
        }
    }

    private func trimPlacedAnchorsIfNeeded() {
        while placedAnchors.count > maxPlacedAnchors {
            let oldestAnchor = placedAnchors.removeFirst()
            oldestAnchor.removeFromParent()
        }
    }

    private func loadModelPrototype(for item: FurnitureItem) -> ModelEntity {
        cacheLock.lock()
        if let cached = modelCache[item.modelFileName] {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()

        let prototype: ModelEntity
        if let loadedModel = try? ModelEntity.loadModel(named: item.modelFileName) {
            prototype = loadedModel
        } else {
            prototype = makeFallbackEntity(for: item)
        }

        prototype.generateCollisionShapes(recursive: true)

        cacheLock.lock()
        modelCache[item.modelFileName] = prototype
        cacheLock.unlock()
        return prototype
    }

    private func makeFallbackEntity(for item: FurnitureItem) -> ModelEntity {
        let material = SimpleMaterial(color: item.tint.withAlphaComponent(0.92), roughness: 0.25, isMetallic: false)
        let mesh: MeshResource

        switch item.fallbackShape {
        case .box:
            mesh = .generateBox(size: 0.35)
        case .cylinder:
            mesh = .generateCylinder(radius: 0.16, height: 0.09)
        case .sphere:
            mesh = .generateSphere(radius: 0.20)
        case .plane:
            mesh = .generatePlane(width: 0.45, depth: 0.45)
        }

        let entity = ModelEntity(mesh: mesh, materials: [material])
        return entity
    }
}

extension ARSessionManager: ARSessionDelegate {
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        let trackingMessage: String

        switch camera.trackingState {
        case .normal:
            trackingMessage = "Tracking is stable. Tap a detected surface to place an item."
        case .notAvailable:
            trackingMessage = "Tracking unavailable. Check lighting and camera visibility."
        case .limited(let reason):
            switch reason {
            case .initializing:
                trackingMessage = "Initializing AR session..."
            case .relocalizing:
                trackingMessage = "Relocalizing. Point the camera to where you started."
            case .excessiveMotion:
                trackingMessage = "Move the iPad more slowly for stable tracking."
            case .insufficientFeatures:
                trackingMessage = "Need more details in view. Scan textured areas."
            @unknown default:
                trackingMessage = "Tracking limited. Adjust lighting and camera angle."
            }
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.appState.placementsCount == 0 || self.appState.statusMessage.contains("Tracking") {
                self.appState.statusMessage = trackingMessage
            }
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.appState.statusMessage = "AR session failed: \(error.localizedDescription)"
        }
    }
}
