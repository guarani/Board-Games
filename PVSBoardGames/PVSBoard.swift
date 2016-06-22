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
    var columns: Int {get set}
    var rows: Int {get set}
    var boardState: [[Int]] {get set}
    var boardSquares: [[UIView]] {get set}
    var boardView: PVSBoardView? {get set}

    func createBoard(options: Dictionary<NSObject, AnyObject>) -> PVSBoard
    func showPopup(string: String)
    func cancelMovement()
    
    func setSquareAtColumn(column: Int, row: Int, color: Bool)
    func clearSquareAtColumn(column: Int, row: Int)
    func clearBoard()
}


class PVSBoard: NSObject, PVSBoardJSExports, PVSBoardViewDelegate, PVSBoardSquareDelegate {
    var gameName: String
    dynamic var columns: Int = 0
    dynamic var rows: Int = 0
    dynamic var boardState: [[Int]] = [[]]
    dynamic var boardSquares: [[UIView]] = [[]]
    dynamic var boardView: PVSBoardView?
    
    var containerView: UIView
    var context: JSContext?
    var viewController: UIViewController?
    
    
    init(createBoardGame: String, inView: UIView, withContext: JSContext, viewController: UIViewController) {
        
        self.gameName = createBoardGame
        self.containerView = inView
        self.context = withContext
        self.viewController = viewController
        
        super.init()
        
        var PVSBoardInterface: @objc_block JSValue -> PVSBoard = {options in
            return self.createBoard(options.toDictionary())
        }

        //
        self.context!.setObject(unsafeBitCast(PVSBoardInterface, AnyObject.self), forKeyedSubscript: "createBoard")
        
        // Open the game.
        let javaScriptPath = NSBundle.mainBundle().pathForResource("games/\(gameName)/game", ofType: "js")
        let javaScriptData = NSData(contentsOfFile: javaScriptPath!)
        let javaScriptString = NSString(data: javaScriptData!, encoding: NSUTF8StringEncoding)
        self.context!.evaluateScript(javaScriptString as! String)
    }
    
    func createBoard(options: Dictionary<NSObject, AnyObject>) -> PVSBoard {
        var title = options["title"] as! String
        var columns = options["columns"] as! Int
        var rows = options["rows"] as! Int
        var pattern = options["pattern"] as! String
        
        self.viewController?.title = title
        self.columns = columns
        self.rows = rows
        self.boardState = Array(count: columns, repeatedValue: Array(count: rows, repeatedValue: Int()))
        self.boardSquares = Array(count: columns, repeatedValue: Array(count: rows, repeatedValue: UIView()))
        self.boardView = PVSBoardView()
        self.boardView!.delegate = self
        self.boardView!.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.boardView!)
        self.containerView.addConstraint(NSLayoutConstraint(item: self.boardView!, attribute: .Width, relatedBy: .Equal, toItem: self.containerView, attribute: .Width, multiplier: 1.0, constant: 0))
        self.containerView.addConstraint(NSLayoutConstraint(item: self.boardView!, attribute: .Height, relatedBy: .Equal, toItem: self.boardView!, attribute: .Width, multiplier: CGFloat(CGFloat(self.rows) / CGFloat(self.columns)), constant: 0))
        
        for row in 0..<self.rows {
            for column in 0..<self.columns {
                var square = PVSBoardSquare(options: ["column": column, "row": row, "pattern": pattern, "columns": self.columns, "rows": self.rows])
                square.delegate = self
                
                self.boardView!.addSubview(square)
                boardSquares[column][row] = square
                
                if column == 0 {
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:|[square]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["square": square]))
                } else if column < self.columns - 1 {
                    var leftSquare = boardSquares[column - 1][row]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:[leftSquare][square]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["leftSquare": leftSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: leftSquare, attribute: .Width, relatedBy: .Equal, toItem: square, attribute: .Width, multiplier: 1.0, constant: 0))
                } else {
                    var leftSquare = boardSquares[column - 1][row]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:[leftSquare][square]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["leftSquare": leftSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: leftSquare, attribute: .Width, relatedBy: .Equal, toItem: square, attribute: .Width, multiplier: 1.0, constant: 0))
                }
                
                if row == 0 {
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:|[square]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["square": square]))
                } else if row < self.rows - 1 {
                    var aboveSquare = boardSquares[column][row - 1]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:[aboveSquare][square]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["aboveSquare": aboveSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: aboveSquare, attribute: .Height, relatedBy: .Equal, toItem: square, attribute: .Height, multiplier: 1.0, constant: 0))
                } else {
                    var aboveSquare = boardSquares[column][row - 1]
                    self.boardView!.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:[aboveSquare][square]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["aboveSquare": aboveSquare, "square": square]))
                    self.boardView!.addConstraint(NSLayoutConstraint(item: aboveSquare, attribute: .Height, relatedBy: .Equal, toItem: square, attribute: .Height, multiplier: 1.0, constant: 0))
                }
            }
        }
        
        return self
    }
    
    func squareTouchedAt(column: Int, row: Int) {
        let squareTouchedAtFunction = self.context!.objectForKeyedSubscript("board").objectForKeyedSubscript("squareTouchedAt")
        if !squareTouchedAtFunction.isUndefined {
            squareTouchedAtFunction.callWithArguments([column, row])
        }
    }
    
    func setSquareAtColumn(column: Int, row: Int, color: Bool) {
        var boardSquareView = self.boardSquares[column][row] as! PVSBoardSquare
        boardSquareView.highlight(color)
    }
    
    func clearSquareAtColumn(column: Int, row: Int) {
        var boardSquareView = self.boardSquares[column][row] as! PVSBoardSquare
        boardSquareView.unhighlight()
    }
    
    func clearBoard() {
        for row in 0..<self.columns {
            for column in 0..<self.rows {
                var boardSquare = self.boardSquares[row][column] as! PVSBoardSquare
                boardSquare.unhighlight()
            }
        }
    }
    
    func cancelMovement() {
        self.boardView!.touchDown = false
    }
    
//    func isFull() -> Bool {
//        var fullSquares = 0
//        for row in 0..<self.columns {
//            for column in 0..<self.rows {
//                var state = self.boardState[column][row] as Int
//                if state == 1 {
//                    fullSquares++
//                }
//            }
//        }
//        if fullSquares == (self.columns * self.rows) {
//            return true
//        } else {
//            return false
//        }
//    }
    
    func showPopup(string: String) {
        let alert = UIAlertView()
        alert.title = "Game Over!"
        alert.message = string
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

    
    func squareClickedAt(column: NSInteger, row: NSInteger) {
        let squareClickedAtFunction = self.context!.objectForKeyedSubscript("board").objectForKeyedSubscript("squareClickedAt")
        if !squareClickedAtFunction.isUndefined {
            squareClickedAtFunction.callWithArguments([column, row])
        }
    }
    

    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var localPosition = touches.anyObject()?.locationInView(self.boardView!)
        print(localPosition)
    }
}
