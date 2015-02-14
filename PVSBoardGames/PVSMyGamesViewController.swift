//
//  PVSMyGamesViewController.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/21/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit

class PVSMyGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var myGames: NSArray = [];
    var selectedGame = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myGames = [
            [
                "title"     : "Cram",
                "directory" : "cram",
            ],
            [
                "title"     : "Noughts & Crosses",
                "directory" : "noughts-and-crosses",
            ],
        ]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myGames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var game: NSDictionary = self.myGames[indexPath.row] as NSDictionary
        cell.textLabel?.text = game["title"] as NSString
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedGame = myGames[indexPath.row]["directory"] as String
        self.performSegueWithIdentifier("GameViewControllerSegue", sender: self)
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var naviagtionController = segue.destinationViewController as UINavigationController
        var nextScreen = naviagtionController.viewControllers[0] as PVSGameViewController
        nextScreen.gameName = selectedGame
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
