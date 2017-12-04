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
    
    //the following variables are set by the presenting view controller
    var session: ARSession!
    var parentNode: SCNNode!
    var position: SCNVector3!
    
    var movementInteraction: Interaction?
    var rotationInteraction: Interaction?
    
    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
            //Configure sceneView
            sceneView.session = session
            sceneView.scene = SCNScene()
            //run the session
            sceneView.session.run(sceneView.session.configuration!)
        }
    }
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
    
    let scale: CGFloat = 0.02
    var grid: Grid!
    var state: Blocks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //in initialize classes
        gameSession = GameSession(gameId: sessionId)
        engine = Engine(sessionId: gameSession.sessionId)
      
        //set the delegates
        sceneView.delegate = self
        sceneView.session.delegate = self
        engine.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //for DEBUGGING
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0))
        cubeNode.position = SCNVector3(0, 0, -0.2)
        sceneView.scene.rootNode.addChildNode(cubeNode)
        //add the node to the root node for DEBUGGING
        sceneView.scene.rootNode.addChildNode(parentNode)
        
        //draw the grid
        grid = Grid(w: 10, h: 10, l: 10,
                    parent: parentNode, scale: scale,
                    color: UIColor.gray.withAlphaComponent(0.9))
        grid.draw()
        state = Blocks(parent: grid.wrapper, scale: scale) 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        gameSession.gameRef.child(name).childByAutoId().setValue(String(describing: action.direction))
    }
    
    func stateChanged(_ state: [Position]) {
        self.state.blocks = state.map{ cell -> ((Int, Int, Int), Int) in
            return ((cell.x, cell.y, cell.z), cell.col)
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
