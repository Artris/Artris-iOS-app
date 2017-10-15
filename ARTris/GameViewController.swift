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

class GameViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    let scale: CGFloat = 0.1
    var grid: Grid!
    var blocks: Blocks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
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
                    color: UIColor.gray.withAlphaComponent(0.7))
        blocks = Blocks(parent: sceneView.scene.rootNode, scale: scale)
        grid.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

