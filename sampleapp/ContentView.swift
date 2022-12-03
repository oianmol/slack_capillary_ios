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
        
        let encrypted = EncryptedData(
            first:"EJyMgvRqIFJ9SAVLxVR50888pyQfTs51idGNQy1TLx64bYHtVcOqb5TguwO9FJIgx8GcJ1NvA9k6FJAA1WpKv27UFIeoRxMq8vnROaZGsslH/WQDZzYW4g4cUONXH/VTkWjNl6PaxuwR8nw0vSaXCFnQ+f16hbZ1NcwXi29lZE/wVdkV67ojOhTkbQrUlQHip/gZINKg197T6UfPeHg0gq7Db+b0AGNRaK8FyFbwJcFPKdrNSOuQBfnwjyzA6Z5n9FLP5+JagSfBl+u+S5+Ysa4/iI5ccme9mftNwBbEd7JKUMU4E86cnEFf840iNsdrD/ZOylaLHidbOQkNDHTi4w==",
            second:"AW3zLU1nipSn119na6PtbtSGlBxF9/E8mvtATahjfAIq8m2oxDc="
        )
        
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
