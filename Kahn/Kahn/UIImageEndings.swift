//
//  UIImageEndings.swift
//  Kahn
//
//  Created by Caleb Jonassaint on 2/23/15.
//  Copyright (c) 2015 Caleb Jonassaint. All rights reserved.
//

import Foundation

public extension Endpoint {
    public func GETImage() -> ((options:[String:AnyObject]?, success:((image:UIImage) -> Void), failure:(() -> Void)) -> Void) {
        return { (options, success, failure) in
            self.method = .GET
            self.makeRequest(options, response: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                if let data = data {
                    if let img = UIImage(data: data) {
                        success(image: img)
                    } else {
                        failure()
                    }
                }
            })
        }
    }
}

