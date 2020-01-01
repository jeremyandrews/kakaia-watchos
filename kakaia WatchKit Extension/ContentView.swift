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
            if audioRecorder.audio_as_text.isEmpty {
                Text("Kakaia")
                    .frame(width: 150, height: 60)
            } else {
                Text(audioRecorder.audio_as_text)
                    .frame(width: 150, height: 60)
            }
            if audioRecorder.recording == 0 {
                Button(action: { self.audioRecorder.startRecording()}) {
                    Image(systemName: "circle.fill")
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .clipped()
                         .foregroundColor(.green)
                }
                    .background(Color.black)
                    .frame(width:100, height: 100)
            } else if audioRecorder.recording == 1 {
                ZStack {
                    Button(action: { self.audioRecorder.stopRecording()}) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .foregroundColor(.red)
                    }
                        .background(Color.black)
                        .frame(width:100, height: 100)
                    Text("(listening)")
                        .padding(.bottom, 5)
                }
            } else {
                ZStack {
                    Button(action: {}) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .foregroundColor(.orange)
                    }
                        .background(Color.black)
                        .frame(width:100, height: 100)
                    Text("(thinking)")
                        .padding(.bottom, 5)
                }

            }

        }
        .frame(width: 150, height: 150)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
