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
    @State private var showModal = false

    var body: some View {
        VStack {
            if audioRecorder.audio_as_text.isEmpty {
                Text("Kakaia")
                    .frame(width: 100, height: 20)
                    .padding()
            } else {
                Button(action: { self.showModal.toggle() }) {
                    Text("Kakaia")
                }
                    .frame(width: 100, height: 20)
                    .padding()
                    .sheet(isPresented: $showModal) {
                        ModalView(showModal: self.$showModal, audio_as_text: self.audioRecorder.audio_as_text)
                }
            }

            if audioRecorder.recording == 0 {
                Button(action: { self.audioRecorder.startRecording()}) {
                    Image(systemName: "circle.fill")
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .clipped()
                         .foregroundColor(.green)
                    }
                    .buttonStyle(PlainButtonStyle())
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
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.black)
                    .frame(width:100, height: 100)
                    Text("(listening)")
                        .padding()
                }
            } else {
                ZStack {
                    Image(systemName: "hand.raised.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.orange)
                        .frame(width:120, height: 100)
                    Text("(thinking)")
                        .padding()
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
