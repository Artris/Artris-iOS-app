import UIKit
import Foundation
import ARKit
import SceneKit

class LocalizationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    var shadow: GridShadow!
    var shadowBinder: SCNNode!
    var objectPosition: CGPoint?
    
    @IBOutlet weak var sceneView: VirtualObjectARView! {
        didSet {
            let rotationHandler = #selector(LocalizationViewController.rotate(byReactingTo:))
            let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: rotationHandler)
            sceneView.addGestureRecognizer(rotationRecognizer)
        }
    }
    
    var screenCentre: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX,y: bounds.midY)
    }

    @objc func rotate(byReactingTo rotationRecognizer: UIRotationGestureRecognizer) {
        guard shadowBinder != nil && rotationRecognizer.state == .changed else { return }
        shadowBinder.eulerAngles.y -= Float(rotationRecognizer.rotation)
        rotationRecognizer.rotation = 0
    }
    
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
        
        //for debugging
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0))
        cubeNode.position = SCNVector3(0, 0, -0.2)
        sceneView.scene.rootNode.addChildNode(cubeNode)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shadowBinder = SCNNode(geometry: nil)
        shadow = GridShadow(w: 10, l: 10, parent: shadowBinder, size: 0.02, color: UIColor.green)
        shadow.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let location = screenCentre
        var objectPosition: float3?
        let object = float3(shadowBinder.position)
        /*if the position is default then the object hasn't been placed yet*/
        if object == float3(0,0,0) {
            objectPosition = nil
        }
        else {
            objectPosition = object
        }
        guard let (worldPosition,_,_) =  sceneView.worldPosition(fromScreenPosition: location, objectPosition: objectPosition)  else { return }

        shadowBinder.position = SCNVector3(worldPosition)
        if objectPosition != nil {
            return
        }
        sceneView.scene.rootNode.addChildNode(shadowBinder)
    }
    

    @IBAction func nextBtnPressed(_ sender: Any) {
        let gameViewController = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        gameViewController.sessionId = "new_game"

        sceneView.session.pause()
        //set the references in next view controller
        gameViewController.session = sceneView.session
        gameViewController.parentNode = shadowBinder
        gameViewController.position = shadowBinder.position

        self.presentView(gameViewController)
    }
}


