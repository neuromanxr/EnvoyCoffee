//
//  EnvoyCoffeeTests.swift
//  EnvoyCoffeeTests
//
//  Created by Kelvin Lee on 1/25/19.
//  Copyright © 2019 Kelvin Lee. All rights reserved.
//

import XCTest
@testable import EnvoyCoffee

class EnvoyCoffeeTests: XCTestCase {
    
    var controllerUnderTest: VenuesViewController!
    
    var venues = [Venue]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controllerUnderTest = VenueRouter.createModule()
        controllerUnderTest.location = .envoy
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controllerUnderTest = nil
        super.tearDown()
    }

    func testGeneralApiCall() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Promises completed")
        
        XCTAssertEqual(self.venues.count, 0, "should be empty before the data task runs")
        
        var params = [String: Any]()
        
        LocationManager.shared.getLatLongFromAddress().get { coordinate in
            debugPrint("coordinate:\(coordinate)")
            params = ["client_id": APIService.clientId, "client_secret": APIService.clientSecret, "ll": coordinate, "query": "coffee", "v": "20180323", "limit": 15]
            }.then { _ in
                SearchManager.shared.searchVenuesForLocation(params: params)
            }.then { venues in
                SearchManager.shared.setPhotoUrls(venues: venues)
            }.get { venues in
                self.venues = venues
                
                promise.fulfill()
            }.ensure {
                
            }.catch { error in
                debugPrint("searchVenuesForLocation error:\(error)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(self.venues.count, 15, "Didn't get expected response from call")
        
        XCTAssertTrue(self.venues.filter { $0.photoUrl != nil }.isEmpty, "photoUrl is nil")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
