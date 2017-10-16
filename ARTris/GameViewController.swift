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
    var engine: Engine!
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
    
    let scale: CGFloat = 0.1
    var grid: Grid!
    var state: Blocks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = Engine()
        engine.delegate = self
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
        grid = Grid(w: 10, h: 10, l: 10,
                    parent: sceneView.scene.rootNode, scale: scale,
                    color: UIColor.gray.withAlphaComponent(0.1))
        state = Blocks(parent: sceneView.scene.rootNode, scale: scale)
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
    }
    
    func stateChanged(_ state: [Position]) {
        self.state.blocks = state.map{ cell -> ((Int, Int, Int), Int) in
            return ((cell.x, cell.z, cell.y), cell.col)
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
