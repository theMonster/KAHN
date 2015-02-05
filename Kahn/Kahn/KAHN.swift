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

public enum HTTPBody {
    case Data(NSData)
    case Custom(Endpoint.BuildDataClosure)
    case Multipart([String: HTTPBody]) // TODO: Make sure the value is not another multipart
}

public class Endpoint {
    public typealias BuildStringClosure = ((options:[String:AnyObject]?) -> String)
    public typealias BuildURLClosure = ((options:[String:AnyObject]?) -> NSURL)
    public typealias BuildDataClosure = ((options:[String:AnyObject]?) -> NSData?)
    
    public var method:HTTPMethod = .GET
    public var baseURL:(NSURL?, BuildURLClosure?)
    public var endpoint:(String?, BuildStringClosure?)
    public var headers:[String:String]?
    public var body:HTTPBody?
    
    public init() {
    
    }
    
    public func setBaseURL(baseURL:NSURL) -> Endpoint {
        self.baseURL = (baseURL, nil)
        return self
    }
    
    public func setBaseURL(closure:BuildURLClosure) -> Endpoint {
        self.baseURL = (nil, closure)
        return self
    }
    
    public func setEndpoint(endpoint:String) -> Endpoint {
        self.endpoint = (endpoint, nil)
        return self
    }
    
    public func setEndpoint(closure:BuildStringClosure) -> Endpoint {
        self.endpoint = (nil, closure)
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
            var url:NSURL
            // get url
            if let baseURL = baseURL.0 {
                url = baseURL
            } else if let baseURLClosure = baseURL.1 {
                url = baseURLClosure(options: options)
            } else {
                fatalError("You must set a baseURL to hit")
            }
            // get endpoint
            var end:String?
            if let endpoint = endpoint.0 {
                end = endpoint
            } else if let endpointClosure = endpoint.1 {
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
        if let b = body {
            switch b {
            case .Data(let data):
                request.HTTPBody = data
            case .Custom(let closure):
                request.HTTPBody = closure(options: options)
            case .Multipart(let parts):
                break // TODO: Do me
            default:
                break
            }
        }
        // set the task and run it
        let task = session.dataTaskWithRequest(request, completionHandler: response)
        task.resume()
    }
}
