//
//  ManageDataColumnDetail.swift
//  Pillar
//
//  Created by Paulo Menezes on 28/02/22.
//

import SwiftUI

struct ManageDataColumnDetail: View {
    @ObservedObject var columns: Columns
    @Binding var columnSelected: Int?

    @State var dataRole = 0
    @State var dataTyle = 0
    @State var name = ""
    
    var body: some View {
        ZStack {
            if columnSelected != nil {
                VStack {
                    HStack {
                        Text("Column Detail")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            columnSelected = nil
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                    }
                        
                    HStack(spacing: 4) {
                        Text("Column Name")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(columns.columns[columnSelected!].originalName)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).foregroundColor(.white)
                    )
                    
                    HStack(spacing: 4) {
                        Text("Name")
                            .foregroundColor(.gray)
                        
                        TextField("", text: $columns.columns[columnSelected!].name)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).foregroundColor(.white)
                    )
                    
                    HStack(spacing: 4) {
                        Text("Hide Column")
                            .foregroundColor(.gray)
                        
//                        Toggle("", isOn: $showOverlay)
//                            .frame(height: 20)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).foregroundColor(.white)
                    )

                    
                    Picker("What is your favorite color?", selection: $dataRole) {
                        Text("Quantitative").tag(0)
                        Text("Nominal").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("What is your favorite color?", selection: $dataTyle) {
                        Text("Text").tag(0)
                        Text("Number").tag(1)
                        Text("Date").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    Spacer()
                }
                    .padding()
                    .frame(width: 300)
                    .frame(maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .foregroundColor(.gray.opacity(0.1))
                    )
                    .padding(.horizontal)
            }
        }
    }
}
