
//
//  PVSBoardSquare.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/22/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit

protocol PVSBoardSquareDelegate {
    func squareClickedAt(column: NSInteger, row: NSInteger)
}


class PVSBoardSquare: UIView {
    
    var delegate: PVSBoardSquareDelegate?
    var column: Int
    var row: Int
    var columns: Int
    var rows: Int
    var pattern: String
    var touchDown: Bool
    
    init(options: NSDictionary) {
        self.column = options["column"] as! Int
        self.row = options["row"] as! Int
        self.columns = options["columns"] as! Int
        self.rows = options["rows"] as! Int
        self.pattern = options["pattern"] as! String
        self.touchDown = false
        
        super.init(frame:CGRectZero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.opaque = false
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("handleTap:")))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight(isPlayer: Bool) {
        if (isPlayer == true) {
            self.backgroundColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 80/255.0, alpha: 1.0)    // Coral.
        } else {
            self.backgroundColor = UIColor(red: 102/255.0, green: 205/255.0, blue: 70/255.0, alpha: 1.0)    // MediumAquamarine.
        }
    }
    
    func unhighlight() {
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func drawRect(rect: CGRect) {
        if pattern == "grid" {
            var context = UIGraphicsGetCurrentContext()
            
            let borderWidth = (1 / UIScreen.mainScreen().scale) * 1.0
            let borderColor = UIColor(red: 30/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1.0).CGColor
            
            
            // Top border for all squares.
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
            CGContextSetStrokeColorWithColor(context, borderColor)
            CGContextSetLineWidth(context, borderWidth)
            CGContextStrokePath(context)
            
            // Right border for all squares.
            CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
            CGContextSetStrokeColorWithColor(context, borderColor)
            CGContextSetLineWidth(context, borderWidth)
            CGContextStrokePath(context)
            
            // A bottom border for all the squares in the last row.
            if row == rows - 1 {
                CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
                CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
                CGContextSetStrokeColorWithColor(context, borderColor)
                CGContextSetLineWidth(context, borderWidth)
                CGContextStrokePath(context)
            }
        } else if pattern == "grid" {
            if ((row + column) % 2) == 0 {
                self.backgroundColor = UIColor.blackColor()
            }
        }
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        self.delegate?.squareClickedAt(self.column, row: self.row)
    }
}
