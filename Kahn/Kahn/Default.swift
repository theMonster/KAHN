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
        return Request(.GET, body: nil)
    }
    
    public func POST(body: NSData?) -> DefaultReturn {
        return POST(HTTPBody.Data(body!))
    }
    
    public func POST(body: BuildDataClosure) -> DefaultReturn {
        return POST(HTTPBody.Custom(body))
    }
    
    public func POST(body: HTTPBody) -> DefaultReturn {
        return Request(.POST, body: body)
    }
    
    public func Request(method: HTTPMethod, body: HTTPBody?) -> DefaultReturn {
        return { (options, response) in
            self.body = body
            self.method = method
            self.makeRequest(options, response)
        }
    }
}
