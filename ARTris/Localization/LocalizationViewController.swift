import UIKit
import Foundation
import ARKit
import SceneKit

class LocalizationViewController: UIViewController,ARSessionDelegate
{
    private var shadow: GridShadow!
    private var shadowBinder: SCNNode!
    private var rotationRecognizer: UIRotationGestureRecognizer!
    private var objectPosition: float3?
    private var objectHasBeenPlaced = false
    private var defaultPlacement = float3(0,0,0)
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
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shadowBinder = SCNNode(geometry: nil)
        shadow = GridShadow(parent: shadowBinder, geometry: .twoD)
        shadow.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let trackingState = sceneView.session.currentFrame?.camera.trackingState {
            updateTrackingStateLabel(trackingstate: trackingState)
        }
        let shadowBinderPosition = float3(shadowBinder.position)
        if shadowBinderPosition != defaultPlacement {
            objectPosition = shadowBinderPosition
            objectHasBeenPlaced = true
        }
        guard let (worldPosition,_,_) =  sceneView.worldPosition(fromScreenPosition: screenCentre, objectPosition: objectPosition) else { return }
        shadowBinder.position = SCNVector3(worldPosition)
        if objectHasBeenPlaced {
            nextBtn.isHidden = false
            return
        }
        sceneView.scene.rootNode.addChildNode(shadowBinder)
    }
    
    @objc private func rotate(byReactingTo rotationRecognizer: UIRotationGestureRecognizer) {
        guard shadowBinder != nil && rotationRecognizer.state == .changed else { return }
        shadowBinder.eulerAngles.y -= Float(rotationRecognizer.rotation)
        rotationRecognizer.rotation = 0
    }
    
    private func updateView() {
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
        sceneView.session.delegate = nil
        updateView()
        view.bringSubview(toFront: backBtn)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "unwindToInitialScene", sender: self)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
    }
}



