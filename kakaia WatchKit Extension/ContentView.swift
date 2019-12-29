//
//  ContentView.swift
//  kakaia WatchKit Extension
//
//  Created by Jeremy Andrews on 12/29/19.
//  Copyright © 2019 Jeremy Andrews. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var audioRecorder: AudioRecorder

    var body: some View {
        VStack {
            Text("Kakaia")
                .font(.title)
            if audioRecorder.recording == false {
                Button(action: { self.audioRecorder.startRecording()}) {
                    Image(systemName: "circle.fill")
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .clipped()
                         .foregroundColor(.green)
                }
                    .background(Color.black)
                    .frame(width:125, height: 100)
            } else {
                ZStack {
                    Button(action: { self.audioRecorder.stopRecording()}) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .foregroundColor(.red)
                    }
                        .background(Color.black)
                        .frame(width:125, height: 100)

                    Text("(listening)")
                        .padding(.bottom, 5)
                }

            }
        }
        .padding(.bottom, -20)
        .frame(width: 150, height: 150)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
