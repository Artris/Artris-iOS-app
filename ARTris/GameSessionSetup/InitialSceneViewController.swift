//
//  GameSessionViewController.swift
//  ARTris
//
//  Created by Grazietta Hof on 2017-11-13.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit

class InitialSceneViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func newGameBtnPressed(_ sender: Any) {
        let gameViewController = storyboard?.instantiateViewController(withIdentifier: "localizationViewController") as! LocalizationViewController
        self.present(gameViewController, animated: false, completion: nil)
    }
    
    @IBAction func findGameBtnPressed(_ sender: Any) {
        let gameListViewController = storyboard?.instantiateViewController(withIdentifier: "gameListViewController") as! GameListViewController
            Firebase.fetchGameSessions(completion: { array in
            gameListViewController.gameSessionsArray = array
            self.present(gameListViewController, animated: false, completion: nil)
        })
    }
    
    @IBAction func unwindToInitialScene(segue: UIStoryboardSegue) {}
}
