//
//  GridShadow.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-29.
//  Copyright © 2017 ARTris. All rights reserved.
//

import SceneKit

class GridTest {
    private let w, l: Int, parent: SCNNode, thicknessRatio: CGFloat, color: UIColor
    private var size: CGFloat
    init(w: Int, l: Int, parent: SCNNode, size: CGFloat, color: UIColor){
        self.w = w; self.l = l
        self.parent = parent
        self.size = size
        self.color = color
        self.scale = 1.0
        self.thicknessRatio = 40.0
    }
    
    private var currSize: CGFloat { return scale * size }
    private var thickness: CGFloat { return currSize / thicknessRatio }
    private var width: CGFloat { return currSize * CGFloat(w) }
    private var length: CGFloat { return currSize * CGFloat(l) }
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
    
    private func linePos(xInd: Int) -> SCNVector3 {
        let x: CGFloat = CGFloat(xInd) * currSize
        return SCNVector3(x, 0, -length / 2)
    }
    
    private func linePos(zInd: Int) -> SCNVector3 {
        let z: CGFloat = -CGFloat(zInd) * currSize
        return SCNVector3(width / 2, 0, z)
    }
    
    private func lineDim(parallelToXAxis: Bool) -> (w: CGFloat, h: CGFloat, l: CGFloat) {
        if parallelToXAxis {
            return (w: width, h: 0, l: thickness)
        }
        return (w: thickness, h: 0, l: length)
    }
    
    private func line(parallelToXAxis: Bool) -> SCNNode {
        let dim = lineDim(parallelToXAxis: parallelToXAxis)
        let cubeGeometry = SCNBox(width: dim.w, height: dim.h, length: dim.l, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        cubeGeometry.materials = [material]
        return SCNNode(geometry: cubeGeometry)
    }
    
    // nodes parallel to x-axis
    lazy private var x_nodes: [SCNNode] = {
        return (0...l).map { z in
            let node = line(parallelToXAxis: true)
            node.position = linePos(zInd: z)
            return node
        }
    }()
    // nodes parallel to z axis {
    lazy private var z_nodes: [SCNNode] = {
        return (0...w).map { x in
            let node = line(parallelToXAxis: false)
            node.position = linePos(xInd: x)
            return node
        }
    }()
    
    func setBoxDim(box: SCNBox, parallelToXAxis: Bool) {
        let dim = lineDim(parallelToXAxis: parallelToXAxis)
        box.width = dim.w
        box.height = dim.h
        box.length = dim.l
    }
    
    var scale: CGFloat {
        didSet {
            //wrapper.position = wrapperPosition ?? redundant
            for (z, n) in x_nodes.enumerated() {
                n.position = linePos(zInd: z)
                let box = n.geometry! as! SCNBox
                setBoxDim(box: box, parallelToXAxis: true)
            }
            
            for (x, n) in z_nodes.enumerated() {
                n.position = linePos(xInd: x)
                let box = n.geometry! as! SCNBox
                setBoxDim(box: box, parallelToXAxis: false)
            }
        }
    }
    
    func draw(){
        x_nodes.forEach { node in wrapper.addChildNode(node) }
        z_nodes.forEach { node in wrapper.addChildNode(node) }
    }
    
    func drawCube() {
        
        
    }
    
}
