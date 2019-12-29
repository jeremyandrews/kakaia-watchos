//
//  ContentView.swift
//  kakaia WatchKit Extension
//
//  Created by Jeremy Andrews on 12/29/19.
//  Copyright © 2019 Jeremy Andrews. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var isListening = false

    var body: some View {
        ZStack {
            if isListening {
                RedCircle()
                    .frame(width:100, height: 75)
            }
            else {
                GreenCirle()
                    .frame(width:100, height: 75)
            }
            
            Button ( action: {
                self.isListening.toggle()
            }) {
                Text("Kakaia")
                    .offset(y: -50)
                if isListening {
                    Text("listening")
                        .frame(width:75, height:75)
                }
            }
            .frame(width:75, height:90)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GreenCirle: View {
    var body: some View {
        Circle().fill(Color.green)
    }
}

struct RedCircle: View {
    var body: some View {
        Circle().fill(Color.red)
    }
}
