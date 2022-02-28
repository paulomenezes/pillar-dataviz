//
//  ManageData.swift
//  Pillar
//
//  Created by Paulo Menezes on 27/02/22.
//

import SwiftUI
import SwiftCSV

struct ManageData: View {
    @State var csvFile: CSV?
    
    @State var sortIndex = -1
    @State var sortType = 0
    
    @State var data: [[String]] = []
    
    @ObservedObject var columns: Columns = Columns(columns: [])
    
    @State var columnSelected: Int?
    
    func load() {
        do {
            let path = Bundle.main.path(forResource: "netflix_titles", ofType: "csv")
            csvFile = try CSV(url: URL(fileURLWithPath: path!))
            
            data = csvFile?.enumeratedRows ?? []
            
            columns.columns = (csvFile?.header ?? []).map({ header in
                Column(
                    originalName: header,
                    name: parseTitle(header),
                    hideColumn: false,
                    role: .quantitative,
                    type: .text
                )
            })
        } catch {
            print("error \(error)")
        }
    }
    
    func parseTitle(_ title: String) -> String {
        return title.split(separator: "_").map { value in
            String(value).capitalizingFirstLetter()
        }.joined(separator: " ")
    }
    
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
                                }
                                
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
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
                .offset(x: columnSelected != nil ? -316 : 0, y: 0)
                .overlay(
                    ManageDataColumnDetail(columns: columns, columnSelected: $columnSelected)
                , alignment: .trailing)
            }
        }
        .onAppear {
            load()
        }
    }
}

struct ManageData_Previews: PreviewProvider {
    static var previews: some View {
        ManageData().previewInterfaceOrientation(.landscapeRight)
    }
}
