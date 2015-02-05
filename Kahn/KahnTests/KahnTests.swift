//
//  KahnTests.swift
//  KahnTests
//
//  Created by Caleb Jonassaint on 12/1/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

import UIKit
import XCTest
import Kahn

class HTTPBin : Endpoint {
    override init() {
        super.init()
        self.setBaseURL(NSURL(string: "https://httpbin.org")!)
    }
}
let get = HTTPBin().setEndpoint("get").GET()
let post = HTTPBin().setEndpoint("post").POST(nil)
let put = HTTPBin().setEndpoint("put").PUT(nil)
let patch = HTTPBin().setEndpoint("patch").PATCH(nil)

class KahnTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHTTPBinGet() {
        runAnEndpoint(get)
    }
    
    func testHTTPBinPost() {
        runAnEndpoint(post)
    }
    
    func testHTTPBinPut() {
        runAnEndpoint(put)
    }
    
    func testHTTPBinPatch() {
        runAnEndpoint(patch)
    }
    
    func runAnEndpoint(closure:Endpoint.DefaultReturn) {
        let e = self.expectationWithDescription("endpoint")
        closure (options: nil) { (data, response, error) -> Void in
            println(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            e.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
