//
//  capillaryios.swift
//  capillaryios
//
//  Created by Anmol Verma on 15/11/22.
//

import Foundation
import Tink

@objc public class CapillaryIOS: NSObject {
    
    @objc public class func initNow(chainId : String, isUnitTest:Bool) {
        let tinkConfig = try! TINKAllConfig.init()
        let config = try! TINKAeadConfig.init()
        let keys = try! SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048, applyUnitTestWorkaround: isUnitTest, chainId: chainId)
        let result = try! SwiftyRSA.addKey(keys.privateKey.data(), isPublic: false, tag: "\(chainId).private")
        let resultR = try! SwiftyRSA.addKey(keys.publicKey.data(), isPublic: true, tag: "\(chainId).public")
    }
    
    @objc public class func publicKey(chainId : String) -> Data? {
        let publicKey =  SwiftyRSA.getKeyTypeInKeyChain(tag:  "\(chainId).public".data(using: .utf8)!,keyClass: kSecAttrKeyClassPublic as String)
        return try! SwiftyRSA.prependX509KeyHeader(keyData: PublicKey(reference: publicKey!).data())
    }
    
    @objc public class func privateKey(chainId : String) -> Data? {
        let privateKey = SwiftyRSA.getKeyTypeInKeyChain(tag:  "\(chainId).private".data(using: .utf8)!,keyClass: kSecAttrKeyClassPrivate as String)
        return try! PrivateKey(reference: privateKey!).data()
    }
        
    @objc public class func encrypt(data:Data,publicKey:Data) -> EncryptedData {
        let symmetricKeyHandle = try! TINKKeysetHandle(keyTemplate: TINKAeadKeyTemplate(keyTemplate: TINKAeadKeyTemplates.TINKAes128Gcm))
        let symmetricKeyBytes = symmetricKeyHandle.serializedKeyset()
        let symmetricKeyCiphertext = try! StoredKey(PublicKey(data: publicKey).reference).encryptBytes(symmetricKeyBytes).message
        let aead = try! TINKAeadFactory.primitive(with: symmetricKeyHandle)
        let payloadCiphertext = try! aead.encrypt(data, withAdditionalData: Data(count: 0))
        return EncryptedData(first: symmetricKeyCiphertext.base64EncodedString(options: []) , second: payloadCiphertext.base64EncodedString(options: []) )
    }
    
    @objc public class func decrypt(symmetricKeyCiphertext:String, payloadCiphertext:String, privateKey:Data) -> Data? {
        let symmetricKeyData = Data.fromBase64(symmetricKeyCiphertext)
        let symmetricKeyBytes = try! StoredKey(PrivateKey(data: privateKey).reference).decryptAsData(symmetricKeyData!)
         let symmetricKeyHandle = try! TINKKeysetHandle(cleartextKeysetHandleWith: TINKBinaryKeysetReader(serializedKeyset: symmetricKeyBytes))
        let aead = try! TINKAeadFactory.primitive(with: symmetricKeyHandle)
        return try! aead.decrypt(Data.fromBase64(payloadCiphertext)!, withAdditionalData: Data(count: 0))
    }
    
    @objc public class func publicKeyFromBytes(data:Data) -> Data? {
        return try! PublicKey(data: data).data()
    }
    
    @objc public class func privateKeyFromBytes(data:Data) -> Data? {
        return try! PrivateKey(data: data).data()
    }

}

extension String {
    public static func fromBase64(_ encoded: String) -> String? {
        if let data = Data.fromBase64(encoded) {
            return String(data: data, encoding: .utf8)
        }
        return nil;
    }
}

extension Data {
    /// Same as ``Data(base64Encoded:)``, but adds padding automatically
    /// (if missing, instead of returning `nil`).
    public static func fromBase64(_ encoded: String) -> Data? {
        // Prefixes padding-character(s) (if needed).
        var encoded = encoded;
        let remainder = encoded.count % 4
        if remainder > 0 {
            encoded = encoded.padding(
                toLength: encoded.count + 4 - remainder,
                withPad: "=", startingAt: 0);
        }

        // Finally, decode.
        return Data(base64Encoded: encoded);
    }
}
