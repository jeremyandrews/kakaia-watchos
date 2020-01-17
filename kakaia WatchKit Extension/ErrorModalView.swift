//
//  ErrorModalView.swift
//  kakaia WatchKit Extension
//
//  Created by Jeremy Andrews on 1/1/20.
//  Copyright © 2020 Jeremy Andrews. All rights reserved.
//

import SwiftUI


struct ErrorModalView: View {
    @Binding var showModal: Bool
    @State var kakaia_response: KakaiaResponse

    var body: some View {
        List {
            Section(header: Text("Not understood:")) {
                Text(kakaia_response.raw)
            }
        }
        .padding()
        .navigationBarTitle("Dismiss")
    }
}

struct ErrorModalView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorModalView(showModal: .constant(true), kakaia_response: KakaiaResponse(raw: "spoken command here"))
    }
}
