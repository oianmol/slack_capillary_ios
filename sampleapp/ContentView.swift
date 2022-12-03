//
//  ContentView.swift
//  sampleapp
//
//  Created by Anmol Verma on 02/12/22.
//

import SwiftUI
import capillaryslack

struct ContentView: View {
    
    @State var str:String = "none"
    
    init() {
        CapillaryIOS.initNow(chainId: "anmol",isUnitTest: false)
        
        let publicKey = CapillaryIOS.publicKey(chainId: "anmol")
        let privateKey = CapillaryIOS.privateKey(chainId: "anmol")!
        
        let encrypted = CapillaryIOS.encrypt(data: "anmol".data(using: .utf8)!, publicKey: publicKey!)
        
        let decrypted = CapillaryIOS.decrypt(symmetricKeyCiphertext: encrypted.first!, payloadCiphertext: encrypted.second!, privateKey: privateKey)
        
        print((publicKey! as NSData).base64EncodedString())
        print((privateKey as NSData).base64EncodedString())
       
     
        if let str = NSString(data: decrypted!, encoding: NSUTF8StringEncoding) as? String {
            print(str)
        } else {
            print("not a valid UTF-8 sequence")
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
