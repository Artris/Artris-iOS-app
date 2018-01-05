//
//  GridShadow.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-29.
//  Copyright © 2017 ARTris. All rights reserved.
//

import SceneKit

class GridShadow
{
    private let w, l, h: Int, parent: SCNNode, thicknessRatio: CGFloat, color: UIColor
    private var size: CGFloat
    
    init(parent:SCNNode, geometry:geometry) {
        self.w = gridConfig.w; self.l = gridConfig.l;
        switch geometry {
        case .twoD:
            self.h = 0
        case .threeD:
            self.h = gridConfig.h
        }
        self.parent = parent
        self.size = gridConfig.size
        self.color = gridConfig.color
        self.thicknessRatio = gridConfig.thicknessRatio
    }

    private var thickness: CGFloat { return size / thicknessRatio }
    private var width: CGFloat { return size * CGFloat(w) }
    private var length: CGFloat { return size * CGFloat(l) }
    private var height: CGFloat { return size * CGFloat(h) }
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
    
    private func linePos(yInd: Int, xInd: Int) -> SCNVector3 {
        let x: CGFloat = CGFloat(xInd) * size
        let y: CGFloat = CGFloat(yInd) * size
        return SCNVector3(x, y, -length / 2)
    }
    
    private func linePos(yInd: Int, zInd: Int) -> SCNVector3 {
        let z: CGFloat = -CGFloat(zInd) * size
        let y: CGFloat = CGFloat(yInd) * size
        return SCNVector3(width / 2, y, z)
    }
    
    private func linePos(zInd: Int, xInd: Int) -> SCNVector3 {
        let x: CGFloat = CGFloat(xInd) * size
        let z: CGFloat = -CGFloat(zInd) * size
        return SCNVector3(x, height / 2, z)
    }
    
    private func lineDim(axis:axis) -> (w: CGFloat, h: CGFloat, l: CGFloat) {
        switch axis {
        case .parallelToXAxis:
            return (w: width, h: 0, l: thickness)
        case .parallelToZAxis:
            return (w: thickness, h: 0, l:length)
        case .parallelToYAxis:
            return (w: thickness, h: height, l:0)
        }
    }
    
    private func line(axis:axis) -> SCNNode {
        let dim = lineDim(axis: axis)
        let cubeGeometry = SCNBox(width: dim.w, height: dim.h, length: dim.l, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        cubeGeometry.materials = [material]
        return SCNNode(geometry: cubeGeometry)
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
 
    // nodes parallel to z-axis
    lazy var x_nodes: [SCNNode] = {
        return permutation(h, w).map { y,x in
            let node = line(axis: .parallelToZAxis)
            node.position = linePos(yInd: y, xInd: x)
            return node
        }
    }()
    
    // nodes parallel to x-axis
    lazy var z_nodes: [SCNNode] = {
        return permutation(h,l).map { y,z in
            let node = line(axis: .parallelToXAxis)
            node.position = linePos(yInd: y, zInd: z)
            return node
        }
    }()
    
    // nodes parallal to y-axis
    lazy var y_nodes: [SCNNode] = {
        return permutation(l, w).map { z,x in
            let node = line(axis: .parallelToYAxis)
            node.position = linePos(zInd: z, xInd: x)
            return node
        }
    }()
    
    func draw() {
        x_nodes.forEach { node in wrapper.addChildNode(node) }
        z_nodes.forEach { node in wrapper.addChildNode(node) }
        y_nodes.forEach { node in wrapper.addChildNode(node) }
    }
}

struct gridConfig {
    static let w = 6
    static let l = 6
    static let h = 6
    static let thicknessRatio = 40 as CGFloat
    static let size = 0.02 as CGFloat
    static let color = UIColor.gray.withAlphaComponent(0.9)
}

enum geometry {
    case twoD
    case threeD
}

enum axis {
    case parallelToXAxis
    case parallelToYAxis
    case parallelToZAxis
}


