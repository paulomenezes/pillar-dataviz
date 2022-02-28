//
//  CreateVisualization.swift
//  Pillar
//
//  Created by Paulo Menezes on 28/02/22.
//

import SwiftUI
import SwiftCSV
import SwiftUICharts

struct CreateVisualization: View {
    @ObservedObject var columns: Columns = Columns(columns: [])

    @Binding var csvFile: CSV?
    @Binding var data: [[String]]
    
    @State var chartType = 0
    @State var xAxis = -1
    @State var yAxis = -1
    @State var groupBy = 0
    
    @State var xAxisExpanded = false
    @State var yAxisExpanded = false
    
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    @State var d: [Double] = []
    
    func updateData() {
        if xAxis > -1 {
            d = data.map { d in
                Double(d[xAxis]) ?? 0
            }
        }
    }
        
    var body: some View {
        HStack {
            VStack {
                List {
                    Section("Chart Type") {
                        Picker("What is your favorite color?", selection: $chartType) {
                            Text("Line").tag(0)
                            Text("Bar").tag(1)
                            Text("Pie").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }

                    Section("Chart Columns") {
                        DisclosureGroup(isExpanded: $xAxisExpanded) {
                            ForEach(columns.columns.indices) { index in
                                Button {
                                    xAxis = xAxis == index ? -1 : index
                                    
                                    if xAxis == yAxis {
                                        yAxis = -1
                                    }
                                    
                                    updateData()
                                    
                                    xAxisExpanded = false
                                    yAxisExpanded = false
                                } label: {
                                    HStack {
                                        Text(columns.columns[index].name)
                                            .foregroundColor(columns.columns[index].hideColumn ? .gray : .black)
                                        
                                        Spacer()
                                        
                                        if xAxis == index {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("X Axis")
                                
                                Spacer()
                                
                                if xAxis != -1 {
                                    Text(columns.columns[xAxis].name)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .foregroundColor(.blue)
                                        )
                                }
                            }
                        }
                        
                        DisclosureGroup(isExpanded: $yAxisExpanded) {
                            ForEach(columns.columns.indices) { index in
                                Button {
                                    yAxis = yAxis == index ? -1 : index
                                    
                                    if xAxis == yAxis {
                                        xAxis = -1
                                    }
                                    
                                    xAxisExpanded = false
                                    yAxisExpanded = false
                                } label: {
                                    HStack {
                                        Text(columns.columns[index].name)
                                            .foregroundColor(columns.columns[index].hideColumn ? .gray : .black)
                                        
                                        Spacer()
                                        
                                        if yAxis == index {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("Y Axis")
                                
                                Spacer()
                                
                                if yAxis != -1 {
                                    Text(columns.columns[yAxis].name)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .foregroundColor(.blue)
                                        )
                                }
                            }
                        }
                    }
                    
                    Section("Group by") {
                        Picker("What is your favorite color?", selection: $groupBy) {
                            Text("Mean").tag(0)
                            Text("Max").tag(1)
                            Text("Min").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }

                }
                .listStyle(.grouped)
            }
            
            VStack {
                BarChart()
                    .data(d)
                    .chartStyle(ChartStyle(backgroundColor: .white, foregroundColor: ColorGradient(.blue, .purple)))
            }
        }
        .padding()
    }
}
