//
//  PVSBoardView.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/24/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit

protocol PVSBoardViewDelegate {
    func squareActivatedAt(column: NSInteger, row: NSInteger)
}

class PVSBoardView: UIView {
    
    var delegate: PVSBoardViewDelegate?
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        println("Touches began: \(touches.anyObject()?.locationInView(self))")
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        println("Touches ended: \(touches.anyObject()?.locationInView(self))")

    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var localPosition = touches.anyObject()?.locationInView(self)
        println("board position: \(localPosition)")
        
        for square in self.subviews {
            var squareView = square as PVSBoardSquare
            var positionInSquare = self.convertPoint(localPosition!, toView: squareView)
            println("square position: \(positionInSquare)")
            if squareView.pointInside(self.convertPoint(localPosition!, toView: squareView), withEvent: event) {
                squareView.highlight()
                self.delegate?.squareActivatedAt(squareView.column, row: squareView.row)
            }
        }
//        println("Touches moved: \(localPosition)")
        
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        println("Hit test \(point)")
        return super.hitTest(point, withEvent: event)
    }

}
