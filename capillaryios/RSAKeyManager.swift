//
//  RSAKeyManager.swift
//  capillaryios
//
//  Created by Anmol Verma on 16/11/22.
//

import Foundation
import SwiftyRSA

class RSAKeyManager {
    public static let KEY_SIZE = 2048
    private var publicKey, privateKey: SecKey?
        
    static let shared = RSAKeyManager()
    let exportImportManager = CryptoExportImportManager()
    
    private func tagPrivate(chainId:String) ->String {
        return "\(Bundle.main.bundleIdentifier ?? "").tagPrivate\(chainId)"
    }
    
    private func tagPublic(chainId:String) ->String {
        return "\(Bundle.main.bundleIdentifier ?? "").tagPublic\(chainId)"
    }
    
    
    public func encrypt(data:Data,publicKey:PublicKey) -> Data? {
        do {
            let clear = ClearMessage(data: data)
            let encryptedMessage = try clear.encrypted(with: publicKey, padding: .OAEP)
            return encryptedMessage.data
        } catch let error {
            //Log error
            debugPrint(error)
            return nil
        }
       
    }
    
    public func decrypt(encryptedMessage:Data,privateKey:PrivateKey) -> Data? {
        do {
            let encrypted = EncryptedMessage(data: encryptedMessage)
            let clear = try encrypted.decrypted(with: privateKey, padding: .OAEP)
            return clear.data
        } catch let error {
            //Log error
            debugPrint(error)
            return nil
        }
    }
    
    
    public func getMyPublicKey(chainId:String) -> PublicKey? {
        do {
            if let pubKey = publicKey {
                return try PublicKey(reference: pubKey)
            } else {
                if getKeysFromKeychain(chainId:chainId), let pubKey = publicKey {
                    return try PublicKey(reference: pubKey)
                } else {
                    generateKeyPair(chainId:chainId)
                    if let pubKey = publicKey {
                        return try PublicKey(reference: pubKey)
                    }
                }
            }
        } catch let error {
            //Log Error
            return nil
        }
        return nil
    }
    
    public func getMyPrivateKey(chainId:String) -> PrivateKey? {
        do {
            if let privKey = privateKey {
                return try PrivateKey(reference: privKey)
            } else {
                if getKeysFromKeychain(chainId:chainId), let privKey = privateKey {
                    return try PrivateKey(reference: privKey)
                } else {
                    generateKeyPair(chainId:chainId)
                    if let privKey = privateKey {
                        return try PrivateKey(reference: privKey)
                    }
                }
            }
        } catch let error {
            //Log Error
            return nil
        }
        return nil
    }
    
    public func getPublicKey(pemEncoded: String) -> PublicKey? {
        do {
            return try PublicKey(pemEncoded: pemEncoded)
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    public func getPublicKey(data: Data) -> PublicKey? {
        do {
            return try PublicKey(data: data)
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    public func getPrivateKey(data: Data) -> PrivateKey? {
        do {
            return try PrivateKey(data: data)
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    //Check Keychain and get keys
    private func getKeysFromKeychain(chainId:String) -> Bool {
        privateKey = getKeyTypeInKeyChain(tag: tagPrivate(chainId:chainId))
        publicKey = getKeyTypeInKeyChain(tag: tagPublic(chainId:chainId))
        return ((privateKey != nil)&&(publicKey != nil))
    }
    
    private func getKeyTypeInKeyChain(tag : String) -> SecKey? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrApplicationTag: tag,
            kSecReturnRef: true
        ]
        
        var result : AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as! SecKey?
        }
        return nil
    }
    
    //Generate private and public keys
    public func generateKeyPair(chainId:String) {
        let privateKeyAttr: [CFString: Any] = [
            kSecAttrIsPermanent: true,
            kSecAttrApplicationTag: tagPrivate
        ]
        let publicKeyAttr: [CFString: Any] = [
            kSecAttrIsPermanent: true,
            kSecAttrApplicationTag: tagPublic
        ]
        
        let parameters: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: RSAKeyManager.KEY_SIZE,
            kSecPrivateKeyAttrs: privateKeyAttr,
            kSecPublicKeyAttrs: publicKeyAttr
        ]
        
        let status = SecKeyGeneratePair(parameters as CFDictionary, &publicKey, &privateKey)
        
        if status != noErr {
            //Log Error
            return
        }
    }
    public func getMyPublicKeyString(chainId:String) -> String? {
        guard let pubKey = self.getMyPublicKey(chainId:chainId)  else {
            return nil
        }
        return exportImportManager.exportRSAPublicKeyToPEM(try! pubKey.data(), keyType: kSecAttrKeyTypeRSA as String, keySize: RSAKeyManager.KEY_SIZE)
    }
    
    //Delete keys when required.
    public func deleteAllKeysInKeyChain() {
        let query : [CFString: Any] = [
            kSecClass: kSecClassKey
        ]
        let status = SecItemDelete(query as CFDictionary)

        switch status {
        case errSecItemNotFound: break
            //No key in keychain
        case noErr: break
            //All Keys Deleted
        default: break
            //Log Error
        }
    }
}
