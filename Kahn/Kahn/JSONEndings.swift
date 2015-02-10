//
//  JSONEndings.swift
//  Kahn
//
//  Created by Caleb Jonassaint on 2/6/15.
//  Copyright (c) 2015 Caleb Jonassaint. All rights reserved.
//

import Foundation

private extension NSData {
    var string:String {
        return NSString(data: self, encoding: NSUTF8StringEncoding)!
    }
    var JSONObject:AnyObject? {
        let s = self.string
        return NSJSONSerialization.JSONObjectWithData(self, options: .allZeros, error: nil)
    }
}

public extension Endpoint {
    public func GETJSON() -> ((options:[String:AnyObject]?, success:((data:AnyObject) -> Void), failure:(() -> Void)) -> Void) {
        return { (options, success, failure) in
            self.method = .GET
            self.addHeaders(["Accept" : "application/json"])
            self.makeRequest(options, response: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                if error == nil && data != nil && response is NSHTTPURLResponse {
                    if let jsonData:AnyObject = data!.JSONObject {
                        success(data: jsonData)
                    } else {
                        failure()
                    }
                } else {
                    failure()
                }
            })
        }
    }
}
