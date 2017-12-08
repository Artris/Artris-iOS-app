import UIKit
import Foundation
import ARKit
import SceneKit

class LocalizationViewController: UIViewController,ARSessionDelegate
{
    var shadow: GridShadow!
    var shadowBinder: SCNNode!
    var objectPosition: CGPoint?
    var rotationRecognizer: UIRotationGestureRecognizer!
    var sessionId: String!
    
    @IBOutlet weak var userPromptLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var sceneView: VirtualObjectARView! {
        didSet {
            let rotationHandler = #selector(LocalizationViewController.rotate(byReactingTo:))
            rotationRecognizer = UIRotationGestureRecognizer(target: self, action: rotationHandler)
            sceneView.addGestureRecognizer(rotationRecognizer)
        }
    }
    @IBOutlet weak var nextBtn: UIButton! {
        didSet {
            nextBtn.isHidden = true
        }
    }
    lazy var gameViewController: GameViewController = {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        viewController.sceneView = sceneView
        viewController.parentNode = shadowBinder
        viewController.sessionId = sessionId
        return viewController
    }()
    var screenCentre: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX,y: bounds.midY)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        shadow = GridShadow(w: 8, l: 8, parent: shadowBinder, size: 0.02, color: UIColor.green)
        /*draw the shadow grid but do not add it to the sceneView yet*/
        shadow.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func rotate(byReactingTo rotationRecognizer: UIRotationGestureRecognizer) {
        guard shadowBinder != nil && rotationRecognizer.state == .changed else { return }
        shadowBinder.eulerAngles.y -= Float(rotationRecognizer.rotation)
        rotationRecognizer.rotation = 0
    }
    
    var eulerAngle_y: Double = 0
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let trackingState = sceneView.session.currentFrame?.camera.trackingState {
            updateTrackingStateLabel(trackingstate: trackingState)
        }
        var objectPosition: float3?
        let shadowBinderPosition = float3(shadowBinder.position)
        
        /*if the position is default then the object hasn't been placed yet*/
        if shadowBinderPosition == float3(0,0,0) {
            objectPosition = nil
        }
       else {
            objectPosition = shadowBinderPosition
        }
        
        guard let (worldPosition,_,_) =  sceneView.worldPosition(fromScreenPosition: screenCentre, objectPosition: objectPosition)  else { return }
        
        shadowBinder.position = SCNVector3(worldPosition)
        if objectPosition != nil {
            nextBtn.isHidden = false
            return
        }
        /*Once a stable position has been found, add the shadowBinder node to the sceneView*/
        sceneView.scene.rootNode.addChildNode(shadowBinder)
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        userPromptLabel.isHidden = true
        nextBtn.isHidden = true
        /*
        Set the scene View Delegate to nil to stabilize the position of the grid
        World tracking is no longer required after the grid has been placed
        */
        sceneView.session.delegate = nil
        updateView()
    }
    
    func updateView() {
        /*Add and configure the GameViewController as a child view controller*/
        self.addChildViewController(gameViewController)
        view.addSubview(gameViewController.view)
        gameViewController.view.frame = view.bounds
        view.bringSubview(toFront: backBtn)
   }
    
    func updateTrackingStateLabel(trackingstate: ARCamera.TrackingState) {
        switch trackingstate {
        case .normal:
            userPromptLabel.text = "The tracking state is normal"
        case .notAvailable:
            userPromptLabel.text = "Keep moving the device around to find a surface"
        case .limited:
            userPromptLabel.text = "Keep moving the device for more accurate results"
        }
    }
}



