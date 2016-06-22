//
//  PVSGameViewController.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/22/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit
import JavaScriptCore


class PVSGameViewController: UIViewController {
    var gameName: String = "cram"
    var context: JSContext = JSContext()
    //var webView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        
        // Initialize the board context interface to JavaScript. From now on we sit back and let the
        // JavaScript code make the game.
        
        var board = PVSBoard(createBoardGame: gameName, inView: self.view, withContext: context, viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
