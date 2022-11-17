//
//  capillaryios.swift
//  capillaryios
//
//  Created by Anmol Verma on 15/11/22.
//

import Foundation
import SwiftyRSA

@objc public class CapillaryIOS: NSObject {
    @objc public class func initNow() {

    }
    
    @objc public class func publicKey() -> Data? {
        return try! RSAKeyManager.shared.getMyPublicKey()?.data()
    }
    
    @objc public class func something() -> String {
        return "anmol"
    }
    
    @objc public class func privateKey() -> Data? {
        return try! RSAKeyManager.shared.getMyPrivateKey()?.data()
    }
    
    @objc public class func publicKeyString() -> String? {
        return RSAKeyManager.shared.getMyPublicKeyString()
    }

}
