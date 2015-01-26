//
//  PVSBoardSquare.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/22/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit

class PVSBoardSquare: UIView {
    
    var column: NSInteger
    var row: NSInteger
    var touchDown: Bool
    
    init(options: NSDictionary) {
        self.column = options["column"] as NSInteger
        self.row = options["row"] as NSInteger
        self.touchDown = false
        super.init(frame:CGRectZero)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        //00    20    40    60    80
        //   11    31    51    71
        //02    22    42    62    82
//        if row == 1 || column == 1 {
//            self.backgroundColor = UIColor.redColor()
//        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight(isPlayer: Bool) {
        if (isPlayer == true) {
            self.layer.borderColor = UIColor.orangeColor().CGColor
        } else {
            self.layer.borderColor = UIColor.greenColor().CGColor
        }
        self.layer.borderWidth = 5
    }
    
    func unhighlight() {
        self.layer.borderWidth = 0
    }


//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.touchDown = true
//        self.layer.borderColor = UIColor.brownColor().CGColor
//        self.layer.borderWidth = 3
//    }
//    
//    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        if self.touchDown == true {
//            self.touchDown = false
//            self.layer.borderWidth = 0
//        }
//    }
//    
//    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//        
////        var localPosition = touches.anyObject()?.locationInView(self)
////        println("C: \(self.column) R: \(self.row) --- \(localPosition)")
////        if localPosition?.x > self.frame.width {
////            self.superview?.hitTes, withEvent: <#UIEvent?#>
////        }
//    }
//    
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//        println("OUTSIDE")
//        
//        return super.hitTest(point, withEvent: event)
//    }

}
