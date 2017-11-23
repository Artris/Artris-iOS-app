//
//  GameSession.swift
//  ARTris
//
//  Created by Grazietta Hof on 2017-11-13.
//  Copyright © 2017 ARTris. All rights reserved.
//

import Foundation
import Firebase

class GameSession {
    
    let gameRef: DatabaseReference
    let sessionId: String
    
    init(gameId: String = "new_game") {
        
        let session = Firebase.sessionsRef
        switch gameId {
        case "new_game":
            gameRef = session.childByAutoId()
            gameRef.child("Rotate").setValue("up") //Delete this: debugging
        default:
            gameRef = session.child(gameId)
        }
        sessionId = gameRef.key
    }
}
