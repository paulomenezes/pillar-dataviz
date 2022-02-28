//
//  ContentView.swift
//  Pillar
//
//  Created by Paulo Menezes on 26/02/22.
//

import SwiftUI
import SwiftCSV
import SigmaSwiftStatistics

struct ContentView: View {
    @State var csvFile: CSV?
    @State var data: [[String]] = []
    
    @State var selectedView: Int? = 1
    
    var menus = ["Upload Data", "Manage Data", "Create Visualization"]
    
    @ObservedObject var columns: Columns = Columns(columns: [])
    
    @State private var workItem: DispatchWorkItem?
    @State private var loaded = false
    
    func load() {
        workItem = DispatchWorkItem {
            DispatchQueue.main.async {
                do {
                    let path = Bundle.main.path(forResource: "netflix_titles", ofType: "csv")
                    csvFile = try CSV(url: URL(fileURLWithPath: path!))
                    
                    data = csvFile?.enumeratedRows ?? []
                    
                    columns.columns = (csvFile?.header ?? []).indices.map({ index in
                        let header = csvFile!.header[index]
                        
                        let column = Column(
                            originalName: header,
                            name: parseTitle(header),
                            hideColumn: false,
                            role: .quantitative,
                            type: .text
                        )
                        
                        var invalid = 0
                        var number = 0
                        var text = 0
                        var date = 0
                        
                        var numbers: [Double] = []
                        
                        for data in csvFile!.enumeratedRows {
                            let value = data[index]
                            
                            if value.isNumeric {
                                number += 1
                                numbers.append(Double(value)!)
                            } else if value.count == 0 {
                                invalid += 1
                            } else {
                                if let d = value.detectDates, !d.isEmpty {
                                    date += 1
                                } else {
                                    text += 1
                                }
                            }
                        }
                        
                        if number > text && number > date {
                            column.role = .quantitative
                            column.type = .number
                        } else if text > number && text > date {
                            column.role = .nominal
                            column.type = .text
                        } else if date > number && date > text {
                            column.role = .nominal
                            column.type = .date
                        }
                        
                        if column.type == .number {
                            column.min = Sigma.min(numbers)
                            column.max = Sigma.max(numbers)
                            column.mean = Sigma.average(numbers)
                            column.median = Sigma.median(numbers)
                            
                            column.bins = ValueDistributor(dataArray: numbers, numberOfBins: 10).feedBins()
                            column.maxBin = (column.bins ?? []).map({ bin in
                                bin.1
                            }).max()
                        }
                        
                        column.invalid = invalid
                        column.invalidPercent = (Double(invalid) / Double(data.count)) * 100
                        
                        return column
                    })
                
                    self.loaded = true
                } catch {
                    print("error \(error)")
                }
            }
        }
        
        if workItem != nil {
            DispatchQueue.global().async(execute: workItem!)
        }
    }
    
    func parseTitle(_ title: String) -> String {
        return title.split(separator: "_").map { value in
            String(value).capitalizingFirstLetter()
        }.joined(separator: " ")
    }
    
    var body: some View {
        if !loaded {
            ProgressView {
                
            }.onAppear {
                load()
            }
        } else {
            NavigationView {
                List {
                    NavigationLink(tag: 0, selection: self.$selectedView) {
                        UploadData()
                            .navigationTitle(menus[0])
                    } label: {
                        HStack {
                            Text(menus[0])
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    
                    NavigationLink(tag: 1, selection: self.$selectedView) {
                        ManageData(
                            columns: columns, csvFile: $csvFile, data: $data
                        )
                            .navigationTitle(menus[1])
                    } label: {
                        HStack {
                            Text(menus[1])
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    
                    NavigationLink(tag: 2, selection: self.$selectedView) {
                        CreateVisualization(
                            columns: columns, csvFile: $csvFile, data: $data
                        )
                            .navigationTitle(menus[2])
                    } label: {
                        HStack {
                            Text(menus[2])
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewInterfaceOrientation(.landscapeRight)
    }
}
