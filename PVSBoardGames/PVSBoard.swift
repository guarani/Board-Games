//
//  PVSBoard.swift
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/22/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit
import JavaScriptCore
import Darwin


@objc protocol PVSBoardJSExports : JSExport  {
    var size: Int {get set}
    var boardState: [[Int]] {get set}
    var boardSquares: [[UIView]] {get set}
    var boardView: PVSBoardView? {get set}

    func createBoardOfSize(size: NSInteger) -> PVSBoard
    
    func setSquareAtColumn(column: NSInteger, row: NSInteger, color: Bool)
    func clearSquareAtColumn(column: NSInteger, row: NSInteger)
    func clearBoard()
    func cancelMovement()
    func isFull() -> Bool
    func showPopup(string: NSString)
}


class PVSBoard: NSObject, PVSBoardJSExports, PVSBoardViewDelegate {
    dynamic var size: Int = 0
    dynamic var boardState: [[Int]] = [[]]
    dynamic var boardSquares: [[UIView]] = [[]]
    dynamic var boardView: PVSBoardView?
    
    var containerView: UIView
    var context: JSContext?
    var viewController: UIViewController?
    
    
    init(createBoardContextInView view: UIView, withContext: JSContext) {
        
        self.containerView = view
        self.context = withContext
        
        super.init()
        
        var PVSBoardInterface: @objc_block JSValue -> PVSBoard = {options in
            let size = options.objectForKeyedSubscript("size").toNumber() as Int
            return self.createBoardOfSize(size)
        }

        //
        self.context!.setObject(unsafeBitCast(PVSBoardInterface, AnyObject.self), forKeyedSubscript: "createBoardOfSize")
        
        let javaScriptPath = NSBundle.mainBundle().pathForResource("game", ofType: "js")
        let javaScriptData = NSData(contentsOfFile: javaScriptPath!)
        let javaScriptString = NSString(data: javaScriptData!, encoding: NSUTF8StringEncoding)
        self.context!.evaluateScript(javaScriptString)
        
    }
    
    func createBoardOfSize(size: NSInteger) -> PVSBoard {
        self.size = size
        self.boardState = Array(count: size, repeatedValue: Array(count: size, repeatedValue: Int()))
        self.boardSquares = Array(count: size, repeatedValue: Array(count: size, repeatedValue: UIView()))
        self.boardView = PVSBoardView()
        self.boardView!.delegate = self
        self.boardView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.boardView!)
        self.containerView.addConstraint(NSLayoutConstraint(item: self.boardView!, attribute: .Width, relatedBy: .Equal, toItem: self.containerView, attribute: .Width, multiplier: 1.0, constant: 0))
        self.containerView.addConstraint(NSLayoutConstraint(item: self.boardView!, attribute: .Height, relatedBy: .Equal, toItem: self.boardView!, attribute: .Width, multiplier: 1.0, constant: 0))
        
        for row in 0..<size {
            for column in 0..<size {
                var square = PVSBoardSquare(options: ["column": column, "row": row])
                
                if ((row + column) % 2) == 0 {
                    square.backgroundColor = UIColor.blackColor()
                }
                
                self.boardView!.addSubview(square)
                boardSquares[column][row] = square
                
                if column == 0 {
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:|[square]", options: .allZeros, metrics: nil, views: ["square": square]))
                } else if column < size - 1 {
                    var leftSquare = boardSquares[column - 1][row]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:[leftSquare][square]", options: .allZeros, metrics: nil, views: ["leftSquare": leftSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: leftSquare, attribute: .Width, relatedBy: .Equal, toItem: square, attribute: .Width, multiplier: 1.0, constant: 0))
                } else {
                    var leftSquare = boardSquares[column - 1][row]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:[leftSquare][square]|", options: .allZeros, metrics: nil, views: ["leftSquare": leftSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: leftSquare, attribute: .Width, relatedBy: .Equal, toItem: square, attribute: .Width, multiplier: 1.0, constant: 0))
                }
                
                if row == 0 {
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:|[square]", options: .allZeros, metrics: nil, views: ["square": square]))
                } else if row < size - 1 {
                    var aboveSquare = boardSquares[column][row - 1]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:[aboveSquare][square]", options: .allZeros, metrics: nil, views: ["aboveSquare": aboveSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: aboveSquare, attribute: .Height, relatedBy: .Equal, toItem: square, attribute: .Height, multiplier: 1.0, constant: 0))
                } else {
                    var aboveSquare = boardSquares[column][row - 1]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:[aboveSquare][square]|", options: .allZeros, metrics: nil, views: ["aboveSquare": aboveSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: aboveSquare, attribute: .Height, relatedBy: .Equal, toItem: square, attribute: .Height, multiplier: 1.0, constant: 0))
                }
                
                
                
            }
        }
        
        return self
    }

    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var localPosition = touches.anyObject()?.locationInView(self.boardView!)
        println(localPosition)
    }
    
    func squareTouchedAt(column: NSInteger, row: NSInteger) {
        self.context!.objectForKeyedSubscript("board").objectForKeyedSubscript("squareTouchedAt").callWithArguments([column, row])
    }
    
    func setSquareAtColumn(column: NSInteger, row: NSInteger, color: Bool) {
        self.boardState[column][row] = 1
        var boardSquareView = self.boardSquares[column][row] as PVSBoardSquare
        boardSquareView.highlight(color)
    }
    
    func clearSquareAtColumn(column: NSInteger, row: NSInteger) {
        self.boardState[column][row] = 0
        var boardSquareView = self.boardSquares[column][row] as PVSBoardSquare
        boardSquareView.unhighlight()
    }
    
    func clearBoard() {
        self.boardState = [[]]
        self.boardState = Array(count: self.size, repeatedValue: Array(count: self.size, repeatedValue: Int()))
        for row in 0..<self.size {
            for column in 0..<size {
                var boardSquare = self.boardSquares[row][column] as PVSBoardSquare
                boardSquare.unhighlight()
                
            }
        }
    }
    
    func cancelMovement() {
        self.boardView!.touchDown = false
    }
    
    func isFull() -> Bool {
        var fullSquares = 0
        for row in 0..<self.size {
            for column in 0..<size {
                var state = self.boardState[column][row] as Int
                if state == 1 {
                    fullSquares++
                }
            }
        }
        if fullSquares == (size * size) {
            return true
        } else {
            return false
        }
    }
    
    func showPopup(string: NSString) {
        let alert = UIAlertView()
        alert.title = "Game Over!"
        alert.message = string
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
}
