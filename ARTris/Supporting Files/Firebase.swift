//
//  Firebase.swift
//  ARTris
//
//  Created by Grazietta Hof on 2017-11-16.
//  Copyright © 2017 ARTris. All rights reserved.
//

import Firebase

class Firebase {
    
    var gameRef: DatabaseReference!
    var dataRef: DatabaseReference!
    
    static let sessionsRef = Firebase.ref.child("game-session")
    static let ref: DatabaseReference = { () -> DatabaseReference in
        FirebaseApp.configure()
        return Database.database().reference()
    }()
    
   static func fetchGameSessions(completion: @escaping(_ array: [String]) -> Void){
        var array = [String]()
        Firebase.sessionsRef.observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    init (sessionId: String) {
         gameRef = Firebase.sessionsRef.child(sessionId)
         dataRef = gameRef.child("grid-render")
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
}
