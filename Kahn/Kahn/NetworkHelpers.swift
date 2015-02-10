//
//  NetworkHelpers.swift
//  Kahn
//
//  Created by Caleb Jonassaint on 2/10/15.
//  Copyright (c) 2015 Caleb Jonassaint. All rights reserved.
//

import Foundation

public extension String {
    public var base64Encode:String {
        let s = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return s
    }
}
