//
//  TimerModalView.swift
//  kakaia WatchKit Extension
//
//  Created by Jeremy Andrews on 1/17/20.
//  Copyright © 2020 Jeremy Andrews. All rights reserved.
//

import SwiftUI


struct TimerModalView: View {
    @Binding var showModal: Bool
    @State var kakaia_response: KakaiaResponse
    @State var timeRemaining: Double

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        List {
            Section(header: Text("Timer:")) {
                Text("\(timeRemaining)")
                    .onReceive(timer) { _ in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        }
                    }
                    .padding()
                Text("\"" + kakaia_response.human + "\"")
                    .padding()
                Text("Raw: \"" + kakaia_response.raw + "\"")
                    .padding()
            }
        }
        .padding()
        .navigationBarTitle("Cancel")
    }
}

struct TimerModalView_Previews: PreviewProvider {
    static var previews: some View {
        TimerModalView(showModal: .constant(true), kakaia_response: KakaiaResponse(human: "set timer for 180 seconds", raw: "set a three minute timer", result: 180.0), timeRemaining: 180)
    }
}
