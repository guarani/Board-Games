//
//  PVSBoardView.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/24/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit

protocol PVSBoardViewDelegate {
    func squareTouchedAt(column: NSInteger, row: NSInteger)
}

class PVSBoardView: UIView {
    
    var delegate: PVSBoardViewDelegate?
    var touchDown: Bool = false
    
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.touchDown = true
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.touchDown = false
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var localPosition = (touches.first as! UITouch).locationInView(self)
        println("board position: \(localPosition)")
        
        if (self.touchDown == true) {
            for square in self.subviews {
                var squareView = square as! PVSBoardSquare
                var positionInSquare = self.convertPoint(localPosition, toView: squareView)
                println("square position: \(positionInSquare)")
                if squareView.pointInside(positionInSquare, withEvent: event) {
                    self.delegate?.squareTouchedAt(squareView.column, row: squareView.row)
                }
            }
        }
//        println("Touches moved: \(localPosition)")
        
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        println("Hit test \(point)")
        return super.hitTest(point, withEvent: event)
    }

}
