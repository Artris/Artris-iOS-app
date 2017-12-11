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
    var gameRef: DatabaseReference!
    var dataRef: DatabaseReference!
    var userIDRef: DatabaseReference!
    var sessionId: String!
    
    static let ref: DatabaseReference = {
        FirebaseApp.configure()
        return Database.database().reference()
    }()
    
    static let gameSessionsRef = Firebase.ref.child("game-session")
    
    init(gameId: String = "new_game") {
        let session = Firebase.gameSessionsRef
        switch gameId {
        case "new_game":
            gameRef = session.childByAutoId()
            gameRef.setValue("initial push")
        default:
            gameRef = session.child(gameId)
        }
        sessionId = gameRef.key
        dataRef = gameRef.child("grid-render")
        userIDRef = gameRef.childByAutoId() 
    }
    
    static func fetchGameSessions(completion: @escaping(_ array: [String]) -> Void) {
        var array = [String]()
            Firebase.gameSessionsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let enumerator = value?.keyEnumerator()
            while let item = enumerator?.nextObject() {
                let key = item as! String
                array.append(key)
            }
            completion(array)
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchPositions(engine: Engine?) {
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
        });
    }
    
    func pushAction(actionName: String, action: Action) {
        print("\(actionName) \(action.direction)")
        userIDRef.child("gestures").child(actionName).childByAutoId().setValue(String(describing: action.direction))
    }
}
    

