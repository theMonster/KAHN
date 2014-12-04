//
//  Service.swift
//  Kahn
//
//  Created by Caleb Jonassaint on 12/1/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

import Foundation

public class ServiceObject {
    
}

public enum HTTPMethod:String {
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

public class Service {
    public func tmp<T:ServiceObject>(method:HTTPMethod, success:((responseObject:T) -> Void), failure:(() -> Void)) {
        
    }
}
