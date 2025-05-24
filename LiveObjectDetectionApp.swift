//
//  LiveObjectDetectionApp.swift
//  LiveObjectDetection
//
//  Created by OpenAI on 2025.
//

import SwiftUI
import RealityKit
import ARKit
import Vision

class ObjectDetectionARView: ARView, ARSessionDelegate {

    private var requests = [VNRequest]()
    private let visionQueue = DispatchQueue(label: "com.liveObjectDetection.visionQueue")

    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.setupARView()
        self.setupVision()
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.frameSemantics = .sceneDepth
        self.session.run(config)
        self.session.delegate = self
    }

    private func setupVision() {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            print("❌ Failed to load CoreML model")
            return
        }

        let request = VNCoreMLRequest(model: model, completionHandler: self.handleDetection)
        request.imageCropAndScaleOption = .centerCrop
        self.requests = [request]
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let pixelBuffer = frame.capturedImage as CVPixelBuffer? else { return }

        visionQueue.async {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            do {
                try handler.perform(self.requests)
            } catch {
                print("⚠️ Vision error: \(error.localizedDescription)")
            }
        }
    }

    private func handleDetection(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation],
              let best = observations.first else { return }

        DispatchQueue.main.async {
            self.showLabel(text: "\(best.identifier) \(String(format: "%.2f", best.confidence))")
        }
    }

    private func showLabel(text: String) {
        self.scene.anchors.removeAll()

        let mesh = MeshResource.generateText(text, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.15), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        let material = SimpleMaterial(color: .systemBlue, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = SIMD3(0, 0, -0.5)

        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(entity)
        self.scene.addAnchor(anchor)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        return ObjectDetectionARView(frame: .zero)
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

@main
struct LiveObjectDetectionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
