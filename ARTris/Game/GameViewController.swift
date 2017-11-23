//
//  ViewController.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-04.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class GameViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, InteractionDelegate, EngineDelegate {

    var gameSession: GameSession!
    var engine: Engine!
    var sessionId: String!
    var shadowBinder: SCNNode!
    
    var movementInteraction: Interaction?
    var rotationInteraction: Interaction?
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var movementView: UIView! {
        didSet {
            movementInteraction = Interaction(name: "Move", view: movementView)
            movementInteraction?.delegate = self
        }
    }
    
    @IBOutlet weak var rotationView: UIView! {
        didSet {
            rotationInteraction = Interaction(name: "Rotate", view: rotationView)
            rotationInteraction?.delegate = self
        }
    }
    
    let scale: CGFloat = 0.2
    var grid: Grid!
    var state: Blocks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSession = GameSession(gameId: sessionId)
        engine = Engine(sessionId: gameSession.sessionId)
        sceneView.delegate = self
        sceneView.session.delegate = self
        engine.delegate = self
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        state = Blocks(parent: sceneView.scene.rootNode, scale: scale)//moved from viewdidAppear sceneView.scene.rootNode
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        grid = Grid(w: 8, h: 12, l: 8,
                    parent: sceneView.scene.rootNode, scale: scale,
                    color: UIColor.gray.withAlphaComponent(0.9))
        grid.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    var eulerAngle_y: Double = 0
    @objc public func session(_ session: ARSession, didUpdate frame: ARFrame){
        eulerAngle_y = Double(frame.camera.eulerAngles.y)
    }
    
    func update(name: String, action: Action){
        print("\(name) \(action.direction)")
        gameSession.gameRef.child(name).childByAutoId().setValue(String(describing: action.direction))
    }
    
    func stateChanged(_ state: [Position]) {
        self.state.blocks = state.map{ cell -> ((Int, Int, Int), Int) in
            return ((cell.x, cell.y, cell.z), cell.col) //state changed delegate called before state is initiliazed
        }
    }
}

extension UISwipeGestureRecognizerDirection: CustomStringConvertible {
    public var description: String {
        var action = "unkown action"
        switch self {
        case .left: action = "left"
        case .right: action = "right"
        case .up: action = "up"
        case .down: action = "down"
        default: break
        }
        return action
    }
}
