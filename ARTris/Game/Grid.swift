//
//  File.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-14.
//  Copyright © 2017 ARTris. All rights reserved.
//

import SceneKit

class Grid
{
    private let w, h, l: Int
    private let parent: SCNNode, scale: CGFloat, color: UIColor, size:CGFloat
    private let diameter: CGFloat
    private var nodes: [SCNNode] = []
    
    init(w: Int, h: Int, l: Int, parent: SCNNode, scale: CGFloat, color: UIColor, diameterRatio: CGFloat = 40.0) {
        self.parent = parent
        self.size = 1.0
        self.scale = scale
        self.color = color
        self.w = w; self.h = h; self.l = l
        self.diameter = scale / diameterRatio
    }
    
    private var currSize: CGFloat { return scale * size }
    private var width: CGFloat { return currSize * CGFloat(w) }
    private var length: CGFloat { return currSize * CGFloat(l) }
    private var wrapperPosition: SCNVector3 {
        let midW =  width / 2
        let midL =   length / 2
        return SCNVector3(-midW, 0, midL)
    }
    lazy var wrapper: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.position = wrapperPosition
        parent.addChildNode(node)
        return node
    }()
    
    private func line(pos: (x: CGFloat, y: CGFloat, z: CGFloat),
                      dim: (w: CGFloat, h: CGFloat, l: CGFloat)) -> SCNNode {
        let cubeGeometry = SCNBox(width: dim.w, height: dim.h, length: dim.l, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        cubeGeometry.materials = [material]
        let node = SCNNode(geometry: cubeGeometry)
        node.position = SCNVector3(
            pos.x + dim.w / 2 ,
            pos.y + dim.h / 2,
            -pos.z - dim.l / 2
        )
        return node
    }
    
    private func permutation(_ a: Int, _ b: Int) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        for i in 0...a {
            for j in 0...b {
                result.append((i, j))
            }
        }
        return result
    }
    
    private func parallelToZAxis() -> [SCNNode] {
        return permutation(w, h).map { (x, y) in
            line(pos: (CGFloat(x) * scale, CGFloat(y) * scale, 0),
                 dim: (diameter, diameter, CGFloat(l) * scale))
        }
    }
    
    private func parallelToXAxis() -> [SCNNode] {
        return permutation(l, h).map { (z, y) in
            line(pos: (0, CGFloat(y) * scale, CGFloat(z) * scale),
                 dim: (CGFloat(w) * scale, diameter, diameter))
        }
    }
    
    private func parallelToYAxis() -> [SCNNode] {
        return permutation(w, l).map { (x, z) in
            line(pos: (CGFloat(x) * scale, 0, CGFloat(z) * scale),
                 dim: (diameter, CGFloat(h) * scale, diameter))
        }
    }
    
    func draw() {
        for node in parallelToZAxis() { nodes.append(node) } // in -z direction
        for node in parallelToXAxis() { nodes.append(node) } // in +x direction
        for node in parallelToYAxis() { nodes.append(node) } // in +y direction
        for node in nodes { wrapper.addChildNode(node) }
    }
}
