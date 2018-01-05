//
//  Firebase.swift
//  ARTris
//
//  Created by Grazietta Hof on 2017-11-16.
//  Copyright © 2017 ARTris. All rights reserved.
//

import Firebase

class Firebase
{
    private var gameRef: DatabaseReference!
    private var dataRef: DatabaseReference!
    private var userIDRef: DatabaseReference!
    
    static private let ref: DatabaseReference = {
        FirebaseApp.configure()
        return Database.database().reference()
    }()
    
    static private let gameSessionsRef = Firebase.ref.child("game-session")
    
    init(gameId: String?) {
        let session = Firebase.gameSessionsRef
        if let gameId = gameId {
            gameRef = session.child(gameId)
        } else {
            gameRef = session.childByAutoId()
            gameRef.setValue("initial push")
        }
        dataRef = gameRef.child("grid-render")
        userIDRef = gameRef.childByAutoId() 
    }
    
    static public func fetchGameSessions(completion: @escaping(_ array: [String]) -> Void) {
        Firebase.gameSessionsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshots = snapshot.value as? NSDictionary
            if let array = snapshots?.allKeys as? [String] {
                completion(array)
            } else {
                completion([String]())
            }
        })
    }
    
    public func fetchPositions(engine: Engine?) {
        self.dataRef.observe(.value, with: { [weak engine] snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                let newState = snapshots.map { snap -> [Position?] in
                    if let cells = snap.children.allObjects as? [DataSnapshot] {
                        return cells.map{ cell -> Position? in
                            if let pos = cell.value as? Dictionary<String, Int> {
                                return Position(dict: pos)
                            }
                            return nil
                        }
                    }
                    return Array<Position?>()
                }
                engine?.state = newState.flatMap { $0.flatMap{ $0 } }
            }
        }) 
    }
    
    public func pushAction(actionName: String, action: Action) {
        print("\(actionName) \(action.direction)")
        userIDRef.child("gestures").child(actionName).childByAutoId().setValue(String(describing: action.direction))
    }
}


