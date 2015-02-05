//
//  Default.swift
//  Kahn
//
//  Created by Caleb Jonassaint on 2/5/15.
//  Copyright (c) 2015 Caleb Jonassaint. All rights reserved.
//

import Foundation

public extension Endpoint {
    public typealias DefaultResponseClosure = ((data:NSData?, response:NSURLResponse?, error:NSError?) -> Void)
    public typealias DefaultReturn = ((options:[String:AnyObject]?, response:DefaultResponseClosure) -> Void)
    
    public func GET() -> DefaultReturn {
        return { (options, response) in
            self.method = .GET
            self.makeRequest(options, response)
        }
    }
    
    public func POST(body:NSData?) -> DefaultReturn {
        return { (options, response) in
            self.body = (body, nil)
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
    
    public func POST(body:BuildDataClosure) -> DefaultReturn {
        return { (options, response) in
            self.body = (nil, body)
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
}
