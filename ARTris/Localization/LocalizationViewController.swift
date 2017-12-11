import UIKit
import Foundation
import ARKit
import SceneKit

class LocalizationViewController: UIViewController,ARSessionDelegate
{
    private var shadow: GridShadow!
    private var shadowBinder: SCNNode!
    private var objectPosition: CGPoint?
    private var rotationRecognizer: UIRotationGestureRecognizer!
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
    private lazy var gameViewController: GameViewController = {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        viewController.sceneView = sceneView
        viewController.parentNode = shadowBinder
        viewController.sessionId = sessionId
        return viewController
    }()
    private var screenCentre: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
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
        /*draw the shadow grid but do not add its parent node to the ARSCNView yet*/
        shadow.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let trackingState = sceneView.session.currentFrame?.camera.trackingState {
            updateTrackingStateLabel(trackingstate: trackingState)
        }
        var objectPosition: float3?
        let shadowBinderPosition = float3(shadowBinder.position)
        
        /*If the position of the shadow binder is the default vector: (0,0,0), keep the objectPosition as nil*/
        if shadowBinderPosition != float3(0,0,0) {
            objectPosition = shadowBinderPosition
        }
        
        /*Perform a hit test at the screen centre*/
        guard let (worldPosition,_,_) =  sceneView.worldPosition(fromScreenPosition: screenCentre, objectPosition: objectPosition) else { return }
        /*update the position of the shadow binder*/
        shadowBinder.position = SCNVector3(worldPosition)
        
        /*Once the object has been placed, the "next" button should appear to allow the user to transition to gameplay*/
        if objectPosition != nil {
            nextBtn.isHidden = false
            return
        }
        /*Once the hit test returns a position, add the shadowBinder node to the ARSCNView*/
        sceneView.scene.rootNode.addChildNode(shadowBinder)
    }
    
    @objc private func rotate(byReactingTo rotationRecognizer: UIRotationGestureRecognizer) {
        guard shadowBinder != nil && rotationRecognizer.state == .changed else { return }
        shadowBinder.eulerAngles.y -= Float(rotationRecognizer.rotation)
        rotationRecognizer.rotation = 0
    }
    
    private func updateView() {
        /*Add the GameViewController as a child viewcontroller*/
        self.addChildViewController(gameViewController)
        view.addSubview(gameViewController.view)
        gameViewController.view.frame = view.bounds
   }
    
    private func updateTrackingStateLabel(trackingstate: ARCamera.TrackingState) {
        switch trackingstate {
        case .normal:
            userPromptLabel.text = "The tracking state is normal"
        case .notAvailable:
            userPromptLabel.text = "The tracking state is not available ... "
        case .limited:
            userPromptLabel.text = "The tracking state is limited ... "
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        userPromptLabel.isHidden = true
        nextBtn.isHidden = true
        /*Set the ARSession Delegate to nil to stabilize the position of the grid*/
        sceneView.session.delegate = nil
        updateView()
        view.bringSubview(toFront: backBtn)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "unwindToInitialScene", sender: self)
    }
}



