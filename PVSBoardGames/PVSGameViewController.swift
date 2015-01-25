//
//  PVSGameViewController.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/22/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit


class PVSGameViewController: UIViewController {
    
    var context: JSContext = JSContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        var console = JSValue(newObjectInContext: context)
        //
        //        var block: @objc_block (NSString!) -> Void = {
        //            (string: NSString!) -> Void in
        //            println(string)
        //        }
        //        console.setObject(unsafeBitCast(block, AnyObject.self), forKeyedSubscript: "console")
        //
        //        let javaScriptPath = NSBundle.mainBundle().pathForResource("game", ofType: "js")
        //        let javaScriptData = NSData(contentsOfFile: javaScriptPath!)
        //        let javaScriptString = NSString(data: javaScriptData!, encoding: NSUTF8StringEncoding)
        //        context.evaluateScript(javaScriptString)
        
    
        self.navigationController?.navigationBar.translucent = false
        
        
        self.context.exceptionHandler = {ctx, exception in
            println("JS Error: \(exception)")
        }
    
        var PVSBoardInterface: @objc_block JSValue -> Void =  {options in
            let size = options.objectForKeyedSubscript("size").toNumber() as Int
            PVSBoard(createBoardOfSize: size, inView: self.view)
        }
        self.context.setObject(unsafeBitCast(PVSBoardInterface, AnyObject.self), forKeyedSubscript: "PVSBoard")
        

//        let sayHello: @objc_block JSValue -> Void = { options in
//            var opts = options.toDictionary()
//            var val = opts["hello"] as Int
//            println("Hi, \(val).")
//        }
//        context.setObject(unsafeBitCast(sayHello, AnyObject.self), forKeyedSubscript: "sayHello")
//        
//        println(context.evaluateScript("sayHello({hello: 42})"))
        
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
