//
//  capillaryslackTests.swift
//  capillaryslackTests
//
//  Created by Anmol Verma on 23/11/22.
//

import XCTest
@testable import capillaryslack

final class capillaryslackTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncryptAndDecryptWithRSA() throws {
        CapillaryIOS.setIsTest(isTest: true)
        CapillaryIOS.initNow(chainId: "anmol")
        
        let publicKey = CapillaryIOS.publicKey(chainId: "anmol")
        let privateKey = CapillaryIOS.privateKey(chainId: "anmol")!

        let encrypted = CapillaryIOS.encrypt(data: "anmol".data(using: .utf8)!, publicKey: publicKey!)!
        XCTAssertNotNil(encrypted)
        
        let decrypted = CapillaryIOS.decrypt(data: encrypted, privateKey: privateKey)
        XCTAssertNotNil(decrypted)
        
        let str = String(decoding: decrypted!, as: UTF8.self)
        XCTAssertEqual(str, "anmol")
        
        
        let publicKeyFromBytes = CapillaryIOS.publicKeyFromBytes(data: publicKey!)
        let privateKeyFromBytes = CapillaryIOS.privateKeyFromBytes(data: privateKey)
        
        let encryptedNext = CapillaryIOS.encrypt(data: "anmolverma".data(using: .utf8)!, publicKey: publicKeyFromBytes!)
        let decryptedNext = CapillaryIOS.decrypt(data: encryptedNext!, privateKey: privateKeyFromBytes!)
        XCTAssertEqual(String(decoding: decryptedNext!, as: UTF8.self), "anmolverma")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
