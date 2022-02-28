//
//  ContentView.swift
//  Pillar
//
//  Created by Paulo Menezes on 26/02/22.
//

import SwiftUI

struct ContentView: View {
    @State var selectedView: Int? = 1
    
    var menus = ["Upload Data", "Manage Data"]
    
    var body: some View {
        NavigationView {
            List(0 ..< menus.count) { index in
                NavigationLink(tag: index, selection: self.$selectedView) {
                    if index == 0 {
                        UploadData()
                            .navigationTitle(menus[index])
                    } else {
                        ManageData()
                            .navigationTitle(menus[index])
                    }
                } label: {
                    HStack {
                        Text(menus[index])
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Pillar")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewInterfaceOrientation(.landscapeRight)
    }
}
