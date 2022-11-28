//
//  EncryptedData.swift
//  capillaryslack
//
//  Created by Anmol Verma on 28/11/22.
//

import Foundation

@objc public class EncryptedData: NSObject {
    
    @objc public private(set) var first: Data?
    @objc public private(set) var second: Data?
    
    private init(_ first: Data?, _ second: Data?) {
        super.init()
        self.first = first
        self.second = second
    }
    
    public convenience init(first: Data?,second:Data?) {
        self.init(first, second)
    }
}
