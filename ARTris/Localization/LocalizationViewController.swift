import UIKit
import Foundation
import ARKit
import SceneKit

class LocalizationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    
 
    var shadow: GridShadow!
    var shadowBinder: SCNNode!
    

    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
//            let rotationHandler = #selector(LocalizationViewController.rotate(byReactingTo:))
//            let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: rotationHandler)
//            sceneView.addGestureRecognizer(rotationRecognizer)

//            let pinchHandler = #selector(LocalizationViewController.scale(byReactingTo:))
//            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: pinchHandler)
//            sceneView.addGestureRecognizer(pinchRecognizer)
//
//            let panHandler = #selector(LocalizationViewController.move(byReactingTo:))
//            let panRecognizer = UIPanGestureRecognizer(target: self, action: panHandler)
//            sceneView.addGestureRecognizer(panRecognizer)
        }
    }

//    @objc func rotate(byReactingTo rotationRecognizer: UIRotationGestureRecognizer){
//        guard shadowBinder != nil && rotationRecognizer.state == .changed else { return }
//        shadowBinder.eulerAngles.y -= Float(rotationRecognizer.rotation)
//        rotationRecognizer.rotation = 0
//    }
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
//        let location = panRecognizer.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(location, types: .featurePoint)
//
//        if let result = hitTestResults.first {
//            let positionColumn = result.worldTransform.columns.3
//            let position = SCNVector3(positionColumn.x, positionColumn.y, positionColumn.z)
//            shadowBinder.worldPosition = position
//            print("*************\(position)")
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
        sceneView.session.run(configuration)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shadowBinder = SCNNode(geometry: nil)
        sceneView.scene.rootNode.addChildNode(shadowBinder)
        shadowBinder.position = SCNVector3(x: -0.0234020855, y: -0.212754607, z: -0.533457279)
        shadow = GridShadow(w: 10, l: 10, parent: shadowBinder, size: 0.02, color: UIColor.green)
        shadow.draw()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        let gameViewController = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        gameViewController.sessionId = "new_game"
        self.presentView(gameViewController)
    }
}

