//
//  Blocks.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-14.
//  Copyright © 2017 ARTris. All rights reserved.
//

import SceneKit

class Blocks
{
    private let parent: SCNNode
    private let scale: CGFloat
    private let chamferRadius: CGFloat
    init(parent: SCNNode, scale: CGFloat = gridConfig.size, chamferRadius: CGFloat = 0.003){
        self.parent = parent
        self.scale = scale
        self.chamferRadius = chamferRadius
    }
    
    private var width: CGFloat { return scale * CGFloat(gridConfig.w) }
    private var length: CGFloat { return scale * CGFloat(gridConfig.l) }
    private var wrapperPosition: SCNVector3 {
        let midW =  width / 2.0
        let midL =   length / 2.0
        return SCNVector3(-midW, 0, midL)
    }
    
    lazy private var wrapper: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.position = wrapperPosition
        parent.addChildNode(node)
        return node
    }()
    
    private var nodes: [SCNNode] = [] {
        didSet {
            for node in oldValue { node.removeFromParentNode() }
            draw()
        }
    }
    
    private func draw(){
        for node in nodes {
            wrapper.addChildNode(node)
        }
    }
    
    private let colorMap: [Int: UIColor] = [
        1: #colorLiteral(red: 0.4196078431, green: 0.831372549, blue: 0.1450980392, alpha: 1),
        2: #colorLiteral(red: 0.6470588235, green: 0.1098039216, blue: 0.1882352941, alpha: 1),
        3: #colorLiteral(red: 0.003921568627, green: 0.5921568627, blue: 0.9647058824, alpha: 1),
        4: #colorLiteral(red: 0.3764705882, green: 0, blue: 0.2784313725, alpha: 1),
        0: #colorLiteral(red: 0.231372549, green: 0.1568627451, blue: 0.8, alpha: 1)
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
                cell(pos: block.pos, color: colorMap[block.col] ?? #colorLiteral(red: 0.4118180871, green: 0.4118918777, blue: 0.4118083119, alpha: 1))
            }
        }
    }
    
}
