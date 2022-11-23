//
//  ContentView.swift
//  TestCapillary
//
//  Created by Anmol Verma on 17/11/22.
//

import SwiftUI
import capillaryslack

struct ContentView: View {
    init(){
        CapillaryIOS.initNow(chainId: "anmol")
    }
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(CapillaryIOS.publicKeyString(chainId: "anmol") ?? "")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
