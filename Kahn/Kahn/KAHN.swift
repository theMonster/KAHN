//
//  KAHN.swift
//  Kahn
//
//  Created by Caleb Jonassaint on 2/5/15.
//  Copyright (c) 2015 Caleb Jonassaint. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

public class Endpoint {
    public typealias BuildStringClosure = ((options:[String:AnyObject]?) -> String)
    public typealias BuildURLClosure = ((options:[String:AnyObject]?) -> NSURL)
    public typealias BuildDataClosure = ((options:[String:AnyObject]?) -> NSData?)
    
    public var method:HTTPMethod = .GET
    public var baseURL:BuildURLClosure?
    public var endpoint:BuildStringClosure?
    public var headers:[String:String]?
    public var body:BuildDataClosure?
    
    public init() {}
    
    public func setBaseURL(baseURL:NSURL) -> Endpoint {
        self.baseURL = { (_) in return baseURL }
        return self
    }
    
    public func setBaseURL(closure:BuildURLClosure) -> Endpoint {
        self.baseURL = closure
        return self
    }
    
    public func setEndpoint(endpoint:String) -> Endpoint {
        self.endpoint = { (_) in return endpoint }
        return self
    }
    
    public func setEndpoint(closure:BuildStringClosure) -> Endpoint {
        self.endpoint = closure
        return self
    }
    
    public func setHeaders(headers:[String:String]) -> Endpoint {
        self.headers = headers
        return self
    }
    
    internal func makeRequest(options:[String:AnyObject]?, response:((data:NSData?, response:NSURLResponse?, error:NSError?) -> Void)) {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        // build url
        func buildFullURL() -> NSURL {
            // get url
            var url:NSURL
            if let baseURLClosure = baseURL {
                url = baseURLClosure(options: options)
            } else {
                fatalError("You must set a baseURL to hit")
            }
            // get endpoint
            var end:String?
            if let endpointClosure = endpoint {
                end = endpointClosure(options: options)
            }
            
            // do we have an endpoint?
            if let end = end {
                url = NSURL(string: url.absoluteString! + "/" + end)!
            }
            return url
        }
        let request = NSMutableURLRequest(URL: buildFullURL())
        request.HTTPMethod = method.rawValue
        request.allHTTPHeaderFields = self.headers
        // get the body if there is one
        if let body = self.body {
            request.HTTPBody = body(options: options)
        }
        // set the task and run it
        let task = session.dataTaskWithRequest(request, completionHandler: response)
        task.resume()
    }
}
