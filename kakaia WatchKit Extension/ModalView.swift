//
//  ModalView.swift
//  kakaia WatchKit Extension
//
//  Created by Jeremy Andrews on 1/1/20.
//  Copyright © 2020 Jeremy Andrews. All rights reserved.
//

import SwiftUI


struct ModalView: View {
    @Binding var showModal: Bool
    @ObservedObject var audioRecorder: AudioRecorder

    var body: some View {
        List {
            Section(header: Text("Audio as text:")) {
                Text(audioRecorder.audio_as_text)
            }
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(showModal: .constant(true), audioRecorder: AudioRecorder())
    }
}
