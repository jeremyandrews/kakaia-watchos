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
    @State var kakaia_response: KakaiaResponse

    var body: some View {
        List {
            Section(header: Text("Command:")) {
                Text(kakaia_response.human)
            }
            Section(header: Text("Raw:")) {
                Text(kakaia_response.raw)
            }
        }
        .padding()
        .navigationBarTitle("Dismiss")
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(showModal: .constant(true), kakaia_response: KakaiaResponse(raw: "this is an example"))
    }
}
