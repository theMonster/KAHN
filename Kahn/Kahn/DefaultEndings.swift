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
            self.makeRequest(options, response: response)
        }
    }
    
    public func POST(body:NSData?) -> DefaultReturn {
        return { (options, response) in
            self.body = { (_) in return body }
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
    
    public func POST(body:BuildDataClosure) -> DefaultReturn {
        return { (options, response) in
            self.body = body
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
    
    public func PUT(body:NSData?) -> DefaultReturn {
        return { (options, response) in
            self.body = { (_) in return body }
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
    
    public func PUT(body:BuildDataClosure) -> DefaultReturn {
        return { (options, response) in
            self.body = body
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
    
    public func PATCH(body:NSData?) -> DefaultReturn {
        return { (options, response) in
            self.body = { (_) in return body }
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
    
    public func PATCH(body:BuildDataClosure) -> DefaultReturn {
        return { (options, response) in
            self.body = body
            self.method = .POST
            self.makeRequest(options, response)
        }
    }
    
    public func DELETE() -> DefaultReturn {
        return { (options, response) in
            self.method = .DELETE
            self.makeRequest(options, response: response)
        }
    }
}
