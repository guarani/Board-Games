//
//  PVSBoardJSInterface.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/25/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit
import JavaScriptCore

class PVSBoardJSInterface: NSObject {
    
    override init() {
        
        var context = JSContext(virtualMachine: JSVirtualMachine())
        var console = JSValue(newObjectInContext: context)
        
        var block: @objc_block (NSString!) -> Void = {
            (string: NSString!) -> Void in
            print(string)
        }
        console.setObject(unsafeBitCast(block, AnyObject.self), forKeyedSubscript: "console")
        
        let javaScriptPath = NSBundle.mainBundle().pathForResource("game", ofType: "js")
        let javaScriptData = NSData(contentsOfFile: javaScriptPath!)
        let javaScriptString = NSString(data: javaScriptData!, encoding: NSUTF8StringEncoding)
        context.evaluateScript(javaScriptString! as String)
    }
}
