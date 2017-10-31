//
//  LocalizationViewController.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-29.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class LocalizationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    var shadow: GridShadow!
    var shadowBinder: SCNNode!
    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
            let rotationHandler = #selector(LocalizationViewController.rotate(byReactingTo:))
            let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: rotationHandler)
            sceneView.addGestureRecognizer(rotationRecognizer)
            
            let pinchHandler = #selector(LocalizationViewController.scale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: pinchHandler)
            sceneView.addGestureRecognizer(pinchRecognizer)
        }
    }
    
    @objc func rotate(byReactingTo rotationRecognizer: UIRotationGestureRecognizer){
        guard shadowBinder != nil && rotationRecognizer.state == .changed else { return }
        shadowBinder.eulerAngles.y -= Float(rotationRecognizer.rotation)
        rotationRecognizer.rotation = 0
    }
    
    @objc func scale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        guard shadow != nil && pinchRecognizer.state == .changed else { return }
        shadow.scale *= pinchRecognizer.scale
        pinchRecognizer.scale = 1
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shadowBinder = SCNNode(geometry: nil)
        sceneView.scene.rootNode.addChildNode(shadowBinder)
        shadow = GridShadow(w: 10, l: 10, parent: shadowBinder, size: 0.1, color: UIColor.green)
        shadow.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}
