//
//  ManageData.swift
//  Pillar
//
//  Created by Paulo Menezes on 27/02/22.
//

import SwiftUI
import SwiftCSV
import SigmaSwiftStatistics

struct ManageData: View {
    @ObservedObject var columns: Columns = Columns(columns: [])

    @Binding var csvFile: CSV?
    @Binding var data: [[String]]

    @State var sortIndex = -1
    @State var sortType = 0
    @State var columnSelected: Int?
    
    func sortData()  {
        data = data.sorted(by: { (a, b) in
            sortType == 0 ? a[sortIndex] > b[sortIndex] : a[sortIndex] < b[sortIndex]
        })
    }
    
    var body: some View {
        ZStack {
            if let csvFile = csvFile {
                let gridColumns = csvFile.header.map({ header in
                    GridItem(spacing: 0)
                })
                
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 0) {
                        ForEach(columns.columns.indices) { index in
                            HStack {
                                Button {
                                    columnSelected = index
                                } label: {
                                    Text(columns.columns[index].name)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                        .foregroundColor(columnSelected == index ? .orange : .blue)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                                
                                Button {
                                    if sortIndex == index {
                                        sortType = sortType == 1 ? 0 : 1
                                    } else {
                                        sortIndex = index
                                        sortType = 0
                                    }
                                    
                                    sortData()
                                } label: {
                                    Image(systemName: sortIndex == index ? sortType == 0 ? "arrowtriangle.down.square.fill" : "arrowtriangle.up.square.fill" : "arrow.up.arrow.down.square.fill")
                                        .foregroundColor(columnSelected == index ? .orange : .blue)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .padding(.horizontal, 4)
                            .background {
                                Rectangle()
                                    .foregroundColor(.gray.opacity(0.2))
                            }
                        }
                        
                        
                        ForEach(data.indices) { row in
                            ForEach(data[row].indices) { item in
                                VStack(spacing: 4) {
                                    Text(data[row][item])
                                        .lineLimit(2)
                                        .font(.subheadline)
                                        .padding(.horizontal, 4)
                                        .frame(maxWidth: .infinity, minHeight: 45, alignment: data[row][item].isNumeric ? .trailing : .leading)
                                
                                    Divider()
                                        .frame(height: 1)
                                }
                                .background {
                                    if columnSelected == item {
                                        Rectangle()
                                            .foregroundColor(.gray.opacity(0.05))
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
                .offset(x: columnSelected != nil && columnSelected! > columns.columns.count - 4 ? -316 : 0, y: 0)
                .overlay(
                    ManageDataColumnDetail(columns: columns, columnSelected: $columnSelected)
                , alignment: .trailing)
            }
        }
    }
}
