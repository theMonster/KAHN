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
        self.baseURL = (NSURL(string: "https://httpbin.org")!, nil)
    }
}
let get = HTTPBin().setEndpoint("get").GET()
let post = HTTPBin().setEndpoint("post").POST(nil)
let customMethod = HTTPBin().setEndpoint("delete").Request(HTTPMethod(rawValue: "DELETE")!, body: nil) // Let's pretent DELETE was not a predefined HTTP method

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
        get (options:nil) { (data, response, error) -> Void in
            println(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
        }
    }
    
    func testHTTPBinPost() {
        post (options:nil) { (data, response, error) -> Void in
            println(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
        }
    }
    
    func testHTTPBinCustom() {
        customMethod (options: nil) { (data, response, error) in
            println(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
        }
    }
}
