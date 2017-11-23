//
//  Engine.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-15.
//  Copyright © 2017 ARTris. All rights reserved.
//

import Foundation

class Position: NSObject {
    let x, y, z, col: Int
    init? (dict: [String: Int]){
        if let x = dict["x"], let y = dict["z"], let z = dict["y"], let col = dict["col"] {
            self.x = x; self.y = y; self.z = z - 1; self.col = col
        } else {
            return nil
        }
    }
    override var description: String {
        return "(\(x), \(y), \(z))"
    }
}

protocol EngineDelegate: class {
    func stateChanged(_ state: [Position])
}

class Engine {
    
    weak var delegate: EngineDelegate?
    var state: [Position] = [] {
        didSet {
            delegate?.stateChanged(state)
        }
    }

    init(sessionId: String = "test") {
        let firebase = Firebase(sessionId: sessionId)
        firebase.fetchPositions(engine: self)
    }
}
