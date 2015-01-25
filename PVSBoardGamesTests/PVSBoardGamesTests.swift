//
//  PVSBoardGamesTests.swift
//  PVSBoardGamesTests
//
//  Created by Paul Von Schrottky on 1/21/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

import UIKit
import XCTest

class PVSBoardGamesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testSetValidCell() {
//        let board = PVSBoard(size: 8)
//        let state :NSInteger = 7
//        board.setCellAt(column: 4, row: 5, state: 7)
//        let result: NSInteger = board.valueAt(column:4, row: 5)
//        XCTAssertEqual(state, result, "Correctly set value.")
//    }
//    
//    func testSetInvalidCell() {
//        let size = 8
//        let state = 2
//        let board = PVSBoard(size: size)
//        board.setCellAt(column: size, row: 3, state: state)
//        XCTFail("Correctly unable to set invalid cell.")
//    }
    
}
