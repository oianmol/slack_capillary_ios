//
//  RSAKeyManager.swift
//  capillaryios
//
//  Created by Anmol Verma on 16/11/22.
//

import Foundation
import Security

class RSAKeyManager {
    public static let KEY_SIZE = 2048
    var isTest: Bool = false
    private var publicKey, privateKey: SecKey?
    static let shared = RSAKeyManager()
    let exportImportManager = CryptoExportImportManager()
    
    func setIsTest(isTest:Bool){
        self.isTest = isTest
    }
    
    private func tagPrivate(chainId:String) ->String {
        return "\(Bundle.main.bundleIdentifier ?? "").\(chainId).tagPrivate"
    }
    
    private func tagPublic(chainId:String) ->String {
        return "\(Bundle.main.bundleIdentifier ?? "").\(chainId).tagPrivate"
    }
    
    
    public func encrypt(data:Data,publicKey:Data) -> Data? {
        do {
            let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
            let encryptedMessageData = SecKeyCreateEncryptedData(try PublicKey(data: publicKey).reference, .rsaEncryptionPKCS1, data as CFData, error) as? Data
            return encryptedMessageData
        } catch let error {
            //Log error
            debugPrint(error)
            return nil
        }
       
    }
    
    public func decrypt(encryptedMessage:Data,privateKey:Data) -> Data? {
        do {
            let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
            let privateKey = try PrivateKey(data:privateKey)
            let decryptedMessage = SecKeyCreateDecryptedData(privateKey.reference, .rsaEncryptionPKCS1, encryptedMessage as CFData, error) as? Data
            return decryptedMessage
        } catch let error {
            //Log Error
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
    
    public func getPublicKey(data: Data) -> Data? {
        do {
            return data
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    public func getPrivateKey(data: Data) -> Data? {
        do {
            return data
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    //Check Keychain and get keys
    private func getKeysFromKeychain(chainId:String) -> Bool {
        let tagData = chainId.data(using: .utf8)
        privateKey = getKeyTypeInKeyChain(tag: tagData!,keyClass: kSecAttrKeyClassPublic as String)
        publicKey =  getKeyTypeInKeyChain(tag: tagData!,keyClass: kSecAttrKeyClassPrivate as String)
        return ((privateKey != nil)&&(publicKey != nil))
    }
    
    private func getKeyTypeInKeyChain(tag : Data,keyClass:String) -> SecKey? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: keyClass,
            kSecAttrApplicationTag: tag,
            kSecReturnRef: true,
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
        if getKeysFromKeychain(chainId:chainId){
            return
        }
        do{
            let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: RSAKeyManager.KEY_SIZE,applyUnitTestWorkaround: isTest,tagData: chainId)
            publicKey =  keyPair.publicKey.reference
            privateKey =  keyPair.privateKey.reference
        } catch let error {
            debugPrint(error)
        }
    }
    public func getMyPublicKeyData(chainId:String) -> Data? {
        guard let pubKey = self.getMyPublicKey(chainId:chainId)  else {
            return nil
        }
        return try! SwiftyRSA.prependX509KeyHeader(keyData: pubKey.data())
    }
    
    public func getMyPrivateKeyData(chainId:String) -> Data? {
        guard let privateKey = self.getMyPrivateKey(chainId:chainId)  else {
            return nil
        }
        let privateKeyFinal = try! SwiftyRSA.addPKCS8Header(privateKey.data())
        return privateKeyFinal
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
