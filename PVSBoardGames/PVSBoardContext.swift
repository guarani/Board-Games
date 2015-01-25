//
//  PVSBoardContext.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/25/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol PVSBoardContextJSExport : JSExport {
    var container: UIView {set get}
}

class PVSBoardContext: NSObject, PVSBoardContextJSExport {
    
    var context: JSContext? = nil
    dynamic var container: UIView;
    
    init(setupJSInterfaceWithContainingView view: UIView, inJSContext jsContext: JSContext) {
        self.container = view
        self.context = jsContext
        
        self.context!.exceptionHandler = {ctx, exception in
            println("JS Error: \(exception)")
        }

        self.context!.setObject(PVSBoardContext.self, forKeyedSubscript: "PVSBoardContext")
        self.context!.setObject(PVSBoard.self, forKeyedSubscript: "PVSBoard")
    }
    

    
    
}
