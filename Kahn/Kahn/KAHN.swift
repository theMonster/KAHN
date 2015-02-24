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

public enum EndpointLogLevel {
    case None, Minimal
}

public class Endpoint {
    public typealias BuildStringClosure = ((options:[String:AnyObject]?) -> String)
    public typealias BuildURLClosure = ((options:[String:AnyObject]?) -> NSURL)
    public typealias BuildDataClosure = ((options:[String:AnyObject]?) -> NSData?)
    public typealias WillHitEndpointClosure = ((completionHandler:((Bool) -> Void)) -> Void)
    public typealias DidHitEndpointClosure = (() -> Void)
    public var method:HTTPMethod = .GET
    public var baseURL:BuildURLClosure?
    public var endpoint:BuildStringClosure?
    public var tokens = [String:String]()
    public var headers = [String:String]()
    public var body:BuildDataClosure?
    public var logLevel:EndpointLogLevel = .None
    public var willHitEndpoint:WillHitEndpointClosure?
    public var didHitEndpoint:DidHitEndpointClosure?
    
    public init() {}
    
    public func setBaseURL(baseURL:NSURL) -> Endpoint {
        self.baseURL = { (_) in return baseURL }
        return self
    }
    
    public func setBaseURL(closure:BuildURLClosure) -> Endpoint {
        self.baseURL = closure
        return self
    }
    
    public func setEndpoint(var endpoint:String) -> Endpoint {
        self.endpoint = { (_) in return endpoint }
        return self
    }

    public func setEndpoint(closure:BuildStringClosure) -> Endpoint {
        self.endpoint = closure
        return self
    }
    
    public func setLogLevel(level:EndpointLogLevel) -> Endpoint {
        self.logLevel = level
        return self
    }
    
    public func setHeaders(headers:[String:String]) -> Endpoint {
        self.headers = headers
        return self
    }
    
    public func addHeaders(headers:[String:String]) -> Endpoint {
        for key in headers.keys {
            self.headers[key] = headers[key]
        }
        return self
    }
    
    public func add(headers:[String:String]) -> Endpoint {
        for key in headers.keys {
            self.headers[key] = headers[key]
        }
        return self
    }
    
    public func setWillHitEndpoint(closure:WillHitEndpointClosure) -> Endpoint {
        self.willHitEndpoint = closure
        return self
    }
    
    public func setDidHitEndpoint(closure:DidHitEndpointClosure) -> Endpoint {
        self.didHitEndpoint = closure
        return self
    }
    
    internal func isValidResponse(data:NSData?, response:NSURLResponse?, error:NSError?) -> Bool {
        return true
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
                var fullStringURL = url.absoluteString! + "/" + end
                // de-tokenize
                if let options = options {
                    for token in tokens {
                        fullStringURL = fullStringURL.stringByReplacingOccurrencesOfString("{\(token.0)}", withString: token.1, options: .LiteralSearch, range: nil)
                    }
                    for option in options {
                        if let value = option.1 as? String {
                            fullStringURL = fullStringURL.stringByReplacingOccurrencesOfString("{\(option.0)}", withString: value, options: .LiteralSearch, range: nil)
                        }
                    }
                }
                url = NSURL(string: fullStringURL)!
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
        // set the task up
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response_var:NSURLResponse!, error:NSError!) -> Void in
            response(data: data, response: response_var, error: error)
            self.didHitEndpoint?()
            return
        })
        
        if let willHitEndpoint = willHitEndpoint {
            willHitEndpoint { (shouldContinue:Bool) in
                if shouldContinue {
                    task.resume()
                }
            }
        } else {
            task.resume()
        }
        // log the task
        switch logLevel {
        case .Minimal:
             println("Kahn: Outgoing HTTP \(method.rawValue) Request to \(request.URL!)")
        default: break
        }
    }
}
