//
//  PVSBoard.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/22/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit

class PVSBoard: NSObject {
    
    var boardState: [[Int]] = [[]]
    var boardSquares: [[UIView]] = [[]]
    
    init(createBoardOfSize size: NSInteger, inView: UIView) {
        
        self.boardState = Array(count: size, repeatedValue: Array(count: size, repeatedValue: Int()))
        self.boardSquares = Array(count: size, repeatedValue: Array(count: size, repeatedValue: UIView()))
        var containerView = PVSBoardView()
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        inView.addSubview(containerView)
        inView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Width, relatedBy: .Equal, toItem: inView, attribute: .Width, multiplier: 1.0, constant: 0))
        inView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: containerView, attribute: .Width, multiplier: 1.0, constant: 0))
        
        for row in 0..<size {
            for column in 0..<size {
                var square = PVSBoardSquare(options: ["column": column, "row": row])
                
                
                if ((row + column) % 2) == 0 {
                    square.backgroundColor = UIColor.blackColor()
                }
                
                containerView.addSubview(square)
                boardSquares[column][row] = square
                
                if column == 0 {
                    containerView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:|[square]", options: .allZeros, metrics: nil, views: ["square": square]))
                } else if column < size - 1 {
                    var leftSquare = boardSquares[column - 1][row]
                    containerView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:[leftSquare][square]", options: .allZeros, metrics: nil, views: ["leftSquare": leftSquare, "square": square]))
                    containerView.addConstraint(NSLayoutConstraint(item: leftSquare, attribute: .Width, relatedBy: .Equal, toItem: square, attribute: .Width, multiplier: 1.0, constant: 0))
                } else {
                    var leftSquare = boardSquares[column - 1][row]
                    containerView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:[leftSquare][square]|", options: .allZeros, metrics: nil, views: ["leftSquare": leftSquare, "square": square]))
                    containerView.addConstraint(NSLayoutConstraint(item: leftSquare, attribute: .Width, relatedBy: .Equal, toItem: square, attribute: .Width, multiplier: 1.0, constant: 0))
                }
                
                if row == 0 {
                    containerView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:|[square]", options: .allZeros, metrics: nil, views: ["square": square]))
                } else if row < size - 1 {
                    var aboveSquare = boardSquares[column][row - 1]
                    containerView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:[aboveSquare][square]", options: .allZeros, metrics: nil, views: ["aboveSquare": aboveSquare, "square": square]))
                    containerView.addConstraint(NSLayoutConstraint(item: aboveSquare, attribute: .Height, relatedBy: .Equal, toItem: square, attribute: .Height, multiplier: 1.0, constant: 0))
                } else {
                    var aboveSquare = boardSquares[column][row - 1]
                    containerView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:[aboveSquare][square]|", options: .allZeros, metrics: nil, views: ["aboveSquare": aboveSquare, "square": square]))
                    containerView.addConstraint(NSLayoutConstraint(item: aboveSquare, attribute: .Height, relatedBy: .Equal, toItem: square, attribute: .Height, multiplier: 1.0, constant: 0))
                }
                

                
            }
        }
    }
    
//    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//        var localPosition = touches.anyObject()?.locationInView(<#view: UIView?#>)
//        println(localPosition)
//    }
    
    
}
