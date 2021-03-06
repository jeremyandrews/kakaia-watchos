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
            if audioRecorder.kakaia_response.raw.isEmpty {
                Text("Kakaia")
                    .frame(width: 100, height: 20)
                    .padding()
                /*
            } else if audioRecorder.kakaia_error {
                Button(action: { self.audioRecorder.showErrorModal.toggle() }) {
                    Text("Kakaia")
                }
                .frame(width: 100, height: 20)
                .padding()
                .sheet(isPresented: $audioRecorder.showErrorModal) {
                    ErrorModalView(showModal: self.$audioRecorder.showErrorModal, kakaia_response: self.audioRecorder.kakaia_response)
                }*/
            } else {
                Button(action: { self.audioRecorder.showTimerModal.toggle() }) {
                    Text("Kakaia")
                }
                .frame(width: 100, height: 20)
                .padding()
                .sheet(isPresented: $audioRecorder.showTimerModal) {
                    TimerModalView(showModal: self.$audioRecorder.showTimerModal, kakaia_response: self.audioRecorder.kakaia_response, timeRemaining: self.audioRecorder.kakaia_response.result)
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
                    Button(action: {  self.audioRecorder.stopRecording()}) {
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
            /*
        .sheet(isPresented: $audioRecorder.showErrorModal) {
            ErrorModalView(showModal: self.$audioRecorder.showErrorModal, kakaia_response: self.audioRecorder.kakaia_response)
        }*/
        .sheet(isPresented: $audioRecorder.showTimerModal) {
            TimerModalView(showModal: self.$audioRecorder.showTimerModal, kakaia_response: self.audioRecorder.kakaia_response, timeRemaining: self.audioRecorder.kakaia_response.result)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
