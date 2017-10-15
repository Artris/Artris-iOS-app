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

struct Action: Hashable {
    let swipe: UISwipeGestureRecognizerDirection
    let orientation: Int
    
    var hashValue: Int {
        return Int(swipe.rawValue) * 4 + orientation.hashValue
    }
    
    static func == (lhs: Action, rhs: Action) -> Bool {
        return lhs.swipe == rhs.swipe && lhs.orientation == rhs.orientation
    }
    
    var direction: UISwipeGestureRecognizerDirection { return Action.map[self]! }
    
    private static let map: [Action : UISwipeGestureRecognizerDirection] = [
        // looking forward
        Action(swipe: .left, orientation: 0) : .left,
        Action(swipe: .right, orientation: 0) : .right,
        Action(swipe: .up, orientation: 0) : .up,
        Action(swipe: .down, orientation: 0) : .down,
        // looking left
        Action(swipe: .left, orientation: 1) : .down,
        Action(swipe: .right, orientation: 1) : .up,
        Action(swipe: .up, orientation: 1) : .left,
        Action(swipe: .down, orientation: 1) : .right,
        // looking back
        Action(swipe: .left, orientation: 2) : .right,
        Action(swipe: .right, orientation: 2) : .left,
        Action(swipe: .up, orientation: 2) : .down,
        Action(swipe: .down, orientation: 2) : .up,
        // looking right
        Action(swipe: .left, orientation: 3) : .up,
        Action(swipe: .right, orientation: 3) : .down,
        Action(swipe: .up, orientation: 3) : .right,
        Action(swipe: .down, orientation: 3) : .left
    ]
}

class GameViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var movementView: UIView! {
        didSet {
            let swipeHandler = #selector(self.swipeHandler(byReactingTo:))
            let supportedDirections: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
            for direction in supportedDirections {
                let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
                swipeRecognizer.direction = direction
                movementView.addGestureRecognizer(swipeRecognizer)
            }
        }
    }
    
    private var direction: Double = 0
    @objc public func session(_ session: ARSession, didUpdate frame: ARFrame){
        direction = Double(frame.camera.eulerAngles.y)
    }
    
    private var orientation: Int {
        switch direction {
        case let d where (-Double.pi / 4 <  d) && (d < Double.pi / 4): return 0
        case let d where (+Double.pi / 4 <  d) && (d < +3 * Double.pi / 4): return 1
        case let d where (-Double.pi / 4 >  d) && (d > -3 * Double.pi / 4): return 3
        default: return 2
        }
    }
    
    var tB = (pos: (0,0,0), 0)    
    @objc func swipeHandler(byReactingTo swipeRecognizer: UISwipeGestureRecognizer){
        let ori  = Action(swipe: swipeRecognizer.direction, orientation: orientation).direction
        switch  ori {
        case .right:
            tB = (pos: (tB.pos.0 + 1, tB.pos.1, tB.pos.2), 0)
        case .down:
            tB = (pos: (tB.pos.0, tB.pos.1, tB.pos.2 + 1), 0)
        case .up:
            tB = (pos: (tB.pos.0, tB.pos.1, tB.pos.2 - 1), 0)
        case .left:
            tB = (pos: (tB.pos.0 - 1, tB.pos.1, tB.pos.2), 0)
        default:
            break
        }
        blocks.blocks = [tB]
    }
    
    @IBOutlet weak var rotationView: UIView!
    
    let scale: CGFloat = 0.1
    var grid: Grid!
    var blocks: Blocks!
    
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
        grid = Grid(w: 10, h: 20, l: 10,
                    parent: sceneView.scene.rootNode, scale: scale,
                    color: UIColor.gray.withAlphaComponent(0.1))
        blocks = Blocks(parent: sceneView.scene.rootNode, scale: scale)
        grid.draw()
        blocks.blocks = [tB]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

