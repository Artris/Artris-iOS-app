//
//  Action.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-15.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit
import ARKit

protocol InteractionDelegate: class {
    var eulerAngle: Double { get }
    func update(name: String, action: Action)
}

class Interaction: NSObject, UIGestureRecognizerDelegate
{
    let name: String
    let view: UIView
    weak var delegate: InteractionDelegate?
    
    init(name: String, view: UIView) {
        self.name = name
        self.view = view
        super.init()
        
        let swipeHandler = #selector(self.swipeHandler(byReactingTo:))
        let supportedDirections: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in supportedDirections {
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
            swipeRecognizer.direction = direction
            self.view.addGestureRecognizer(swipeRecognizer)
        }
    }
    
    @objc func swipeHandler(byReactingTo swipeRecognizer: UISwipeGestureRecognizer) {
        let action  = Action(swipe: swipeRecognizer.direction, orientation: orientation)
        delegate?.update(name: name, action: action)
    }
    
    private var orientation: Int {
        let direction: Double = delegate?.eulerAngle ?? 0
        switch direction {
        case let d where (-Double.pi / 4 <  d) && (d < Double.pi / 4): return 0
        case let d where (+Double.pi / 4 <  d) && (d < +3 * Double.pi / 4): return 1
        case let d where (-Double.pi / 4 >  d) && (d > -3 * Double.pi / 4): return 3
        default: return 2
        }
    }
}
