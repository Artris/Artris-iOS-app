//
//  File.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-14.
//  Copyright © 2017 ARTris. All rights reserved.
//

import SceneKit

class Grid {
    private let w, h, l: Int
    private let parent: SCNNode, scale: CGFloat, color: UIColor
    private let diameter: CGFloat
    private var nodes: [SCNNode] = []
    
    init(w: Int, h: Int, l: Int, parent: SCNNode, scale: CGFloat, color: UIColor, diameterRatio: CGFloat = 40.0){
        self.parent = parent
        self.scale = scale
        self.color = color
        self.w = w; self.h = h; self.l = l
        self.diameter = scale / diameterRatio
    }
    
    private func line(pos: (x: CGFloat, y: CGFloat, z: CGFloat),
                      dim: (w: CGFloat, h: CGFloat, l: CGFloat)) -> SCNNode {
        let cubeGeometry = SCNBox(width: dim.w, height: dim.h, length: dim.l, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        cubeGeometry.materials = [material]
        let node = SCNNode(geometry: cubeGeometry)
        node.position = SCNVector3(
            pos.x + dim.w / 2 - 1,
            pos.y + dim.h / 2,
            -pos.z - dim.l / 2 - 3
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
        for node in nodes { parent.addChildNode(node) }
    }
}
