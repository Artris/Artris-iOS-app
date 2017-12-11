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

class GameViewController: UIViewController, InteractionDelegate, EngineDelegate, ARSessionDelegate
{
    private var engine: Engine!
    private var firebase: Firebase!
    private var grid: Grid!
    private var state: Blocks!
    var sceneView: ARSCNView!
    var sessionId: String!
    
    private var movementInteraction: Interaction?
    private var rotationInteraction: Interaction?
    
    var scale: CGFloat = 0.02
    var parentNode: SCNNode!
    var eulerAngle_y: Double = 0

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

    override func viewDidLoad() {
        super.viewDidLoad()
        if sessionId != nil {
            firebase = Firebase(gameId: sessionId)
        } else { firebase = Firebase() }
        engine = Engine(database: firebase)
        engine.delegate = self
        sceneView.session.delegate = self
        state = Blocks(parent: parentNode, scale: scale)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.scene.rootNode.addChildNode(parentNode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        grid = Grid(w: 8, h: 8, l: 8,
                    parent: parentNode, scale: scale,
                    color: UIColor.gray.withAlphaComponent(0.9))
        grid.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @objc public func session(_ session: ARSession, didUpdate frame: ARFrame) { 
        eulerAngle_y = Double(frame.camera.eulerAngles.y)
    }
    
    func update(name: String, action: Action){
        firebase.pushAction(actionName: name, action: action)
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
