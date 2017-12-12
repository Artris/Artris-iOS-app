//
//  gameListViewController.swift
//  ARTris
//
//  Created by Grazietta Hof on 2017-11-13.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit

class GameListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var gameSessionsArray:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameSessionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameSessionCell") as! GameSessionCell
        cell.label.text = gameSessionsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sessionId = gameSessionsArray[indexPath.row]
        let localizationViewController = storyboard?.instantiateViewController(withIdentifier: "localizationViewController") as! LocalizationViewController
        localizationViewController.sessionId = sessionId
        self.present(localizationViewController, animated: false, completion: nil)
    }

    @IBAction func backBtnPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "unwindToInitialScene", sender: self)
    }
}

class GameSessionCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
