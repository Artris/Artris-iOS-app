//
//  Action.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-15.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit
import ARKit

struct Action: Hashable
{
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
