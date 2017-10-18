//
//  Blocks.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-14.
//  Copyright © 2017 ARTris. All rights reserved.
//

import SceneKit

class Blocks {
    private let parent: SCNNode
    private let scale: CGFloat
    private let chamferRadius: CGFloat
    init(parent: SCNNode, scale: CGFloat, chamferRadius: CGFloat = 0.02){
        self.parent = parent
        self.scale = scale
        self.chamferRadius = chamferRadius
    }
    
    private var nodes: [SCNNode] = [] {
        didSet {
            for node in oldValue { node.removeFromParentNode() }
            draw()
        }
    }
    
    private func draw(){
        for node in nodes {
            parent.addChildNode(node)
        }
    }
    
    private let colorMap: [Int: UIColor] = [
        1 : UIColor.green,
        2: UIColor.blue,
        3: UIColor.red,
        4: UIColor.yellow,
        0: UIColor.black
    ]
    
    private func cell(pos: (x: Int, y: Int, z: Int), color: UIColor) -> SCNNode {
        let cubeGeometry = SCNBox(width: scale, height: scale, length: scale, chamferRadius: chamferRadius)
        let material = SCNMaterial()
        material.diffuse.contents = color
        cubeGeometry.materials = [material]
        let node = SCNNode(geometry: cubeGeometry)
        node.position = SCNVector3(
            CGFloat(pos.x) * scale + scale / 2,
            CGFloat(pos.y) * scale + scale / 2,
            -CGFloat(pos.z) * scale - scale / 2
        )
        return node
    }
    
    var blocks: [(pos: (Int, Int, Int), col: Int)] = [] {
        didSet {
            nodes = blocks.map{ block in
                cell(pos: block.pos, color: colorMap[block.col] ?? UIColor.purple)
            }
        }
    }
    
}
