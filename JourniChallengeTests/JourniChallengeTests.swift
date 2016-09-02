//
//  JourniChallengeTests.swift
//  JourniChallengeTests
//
//  Created by Bruno Paulino on 9/2/16.
//  Copyright © 2016 brunojppb. All rights reserved.
//

import XCTest
@testable import JourniChallenge

class JourniChallengeTests: XCTestCase {
    
    var vc: ChallengeViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        vc = storyboard.instantiateInitialViewController() as! ChallengeViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParser() {
        let validJson = GEOJSONParser.sharedInstance.parseGEOJSONFile("countries_small")
        XCTAssert(validJson != nil)
        
        let invalidJson = GEOJSONParser.sharedInstance.parseGEOJSONFile("invalid_countries")
        XCTAssert(invalidJson == nil)
        
    }
    
    func testNumberOfPolygons() {
        vc.startupChallenge()
        XCTAssert(vc.polygons.count == 462)
    }
    
    func testSetupScrollView() {
        vc.setupScrollView()
        XCTAssert(vc.scrollView != nil)
    }
    
    func testSetupMapView() {
        vc.startupChallenge()
        XCTAssert(vc.mapView != nil)
    }
    
    
}
