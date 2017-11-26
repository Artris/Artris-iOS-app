import UIKit
import Foundation
import ARKit
import SceneKit

class LocalizationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    
 
    var shadow: GridShadow!
    var shadowBinder: SCNNode!
    
    

    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
            let rotationHandler = #selector(LocalizationViewController.rotate(byReactingTo:))
            let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: rotationHandler)
            sceneView.addGestureRecognizer(rotationRecognizer)

//            let pinchHandler = #selector(LocalizationViewController.scale(byReactingTo:))
//            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: pinchHandler)
//            sceneView.addGestureRecognizer(pinchRecognizer)
//
//            let panHandler = #selector(LocalizationViewController.move(byReactingTo:))
//            let panRecognizer = UIPanGestureRecognizer(target: self, action: panHandler)
//            sceneView.addGestureRecognizer(panRecognizer)
        }
    }
    
    var screenCentre: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX,y: bounds.midY)
    }

    @objc func rotate(byReactingTo rotationRecognizer: UIRotationGestureRecognizer){
        guard shadowBinder != nil && rotationRecognizer.state == .changed else { return }
        shadowBinder.eulerAngles.y -= Float(rotationRecognizer.rotation)
        rotationRecognizer.rotation = 0
    }
//
//    @objc func scale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
//        guard shadow != nil && pinchRecognizer.state == .changed else { return }
//        shadow.scale *= pinchRecognizer.scale
//        pinchRecognizer.scale = 1
//    }
//
//    @objc func move(byReactingTo panRecognizer: UIPanGestureRecognizer){
//        guard shadowBinder != nil && panRecognizer.state == .changed else { return }
//
//        let location = sceneView.center
//        let hitTestResults = sceneView.hitTest(location, types: .featurePoint)
//
//        if let result = hitTestResults.first {
//            let positionColumn = result.worldTransform.columns.3
//            let position = SCNVector3(positionColumn.x, positionColumn.y, positionColumn.z)
//            shadowBinder.worldPosition = position
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.scene = SCNScene()
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shadowBinder = SCNNode(geometry: nil)
        sceneView.scene.rootNode.addChildNode(shadowBinder)
        shadow = GridShadow(w: 10, l: 10, parent: shadowBinder, size: 0.02, color: UIColor.green)
        shadow.draw()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let location = screenCentre
        let hitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if let result = hitTestResults.first {
            var positionColumn = result.worldTransform.columns.3
            let position = SCNVector3(positionColumn.x, positionColumn.y, positionColumn.z)
            shadowBinder.position = position
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        let gameViewController = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        gameViewController.sessionId = "new_game"
        sceneView.session.pause()
        gameViewController.session = sceneView.session
        gameViewController.scene = sceneView.scene
        gameViewController.parentNode = shadowBinder
        self.presentView(gameViewController)
    }
}

