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

class KahnTests: XCTestCase {
    class HTTPBin : Endpoint {
        override init() {
            super.init()
            self.baseURL = (NSURL(string: "https://httpbin.org")!, nil)
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHTTPBinGet() {
        let get = HTTPBin().setEndpoint("get").GET()
        get (options:nil) { (data, response, error) -> Void in
            println(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
        }
    }
    
    func testHTTPBinPost() {
        let post = HTTPBin().setEndpoint("post").POST(nil)
        post (options:nil) { (data, response, error) -> Void in
            println(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
        }
    }
}
