//
//  ContentView.swift
//  TestCapillary
//
//  Created by Anmol Verma on 17/11/22.
//

import SwiftUI
import capillaryios

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(CapillaryIOS.publicKeyString() ?? "")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
