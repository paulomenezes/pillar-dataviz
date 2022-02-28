//
//  UploadData.swift
//  Pillar
//
//  Created by Paulo Menezes on 26/02/22.
//

import SwiftUI

struct UploadData: View {
    @State var fileURL: String = ""
    @State var type = 2
    @State var sampleDatasetItem: String?
    
    var sampleDatasets = ["Netflix", "COVID"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("How do you want to upload your data?")
                .fontWeight(.bold)
            
            Picker("What is your favorite color?", selection: $type) {
                Text("Upload CSV").tag(0)
                Text("Chose from URL").tag(1)
                Text("Sample Dataset").tag(2)
            }
            .pickerStyle(.segmented)
            
            if type == 0 {
                TextField("File URL", text: $fileURL)
            } else if type == 1 {
                
            } else if type == 2 {
                List {
                    ForEach(sampleDatasets, id: \.self) { item in
                        Button {
                            sampleDatasetItem = item
                        } label: {
                            HStack {
                                Text(item)
                                Spacer()
                                
                                if sampleDatasetItem != nil && item == sampleDatasetItem! {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                        }
                    }
                }
            }
            
            Button {
                
            } label: {
                Text("Enviar")
            }
            .buttonStyle(.borderedProminent)
        }.padding()
    }
}

struct UploadData_Previews: PreviewProvider {
    static var previews: some View {
        UploadData().previewInterfaceOrientation(.landscapeRight)
    }
}
