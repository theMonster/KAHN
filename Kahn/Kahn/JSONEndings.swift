//
//  JSONEndings.swift
//  Kahn
//
//  Created by Caleb Jonassaint on 2/6/15.
//  Copyright (c) 2015 Caleb Jonassaint. All rights reserved.
//

import Foundation

private extension NSDictionary {
    var JSONData:NSData? {
        return NSJSONSerialization.dataWithJSONObject(self, options: .allZeros, error: nil)
    }
}

private extension NSData {
    var string:String {
        return NSString(data: self, encoding: NSUTF8StringEncoding)! as String
    }
    var JSONObject:AnyObject? {
        return NSJSONSerialization.JSONObjectWithData(self, options: .allZeros, error: nil)
    }
}

public extension Endpoint {
    public func GETJSON() -> ((options:[String:AnyObject]?, success:((data:AnyObject) -> Void), failure:(() -> Void)) -> Void) {
        return { (options, success, failure) in
            self.method = .GET
            self.addHeaders(["Content-Type" : "application/json"])
            self.makeRequest(options, response: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
            })
        }
    }
    
    public func POSTJSON() -> ((body:NSDictionary?, options:[String:AnyObject]?, success:((data:AnyObject) -> Void), failure:(() -> Void)) -> Void) {
        return { (body, options, success, failure) in
            self.method = .POST
            self.body = { (options) in
                return body?.JSONData
            }
            self.addHeaders(["Content-Type" : "application/json"])
            self.makeRequest(options, response: { (data, response, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
            })
        }
    }
    
    public func POSTRAW() -> ((body:NSData?, options:[String:AnyObject]?, success:((data:AnyObject) -> Void), failure:(() -> Void)) -> Void) {
        return { (body, options, success, failure) in
            self.method = .POST
            self.body = { (options) in
                return body
            }
            self.addHeaders(["Content-Type" : "application/json"])
            self.makeRequest(options, response: { (data, response, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
            })
        }
    }
}
