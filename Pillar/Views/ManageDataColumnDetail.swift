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

    @State var name = ""
    
    var role: Binding<Int> {
        Binding<Int>(
            get: {
                columns.columns[columnSelected!].role.rawValue
            },
            set: {
                columns.columns[columnSelected!].role = ColumnRole(rawValue: $0) ?? ColumnRole.nominal
            }
        )
    }
    
    var type: Binding<Int> {
        Binding<Int>(
            get: {
                columns.columns[columnSelected!].type.rawValue
            },
            set: {
                columns.columns[columnSelected!].type = ColumnType(rawValue: $0) ?? ColumnType.number
            }
        )
    }

    
    var body: some View {
        ZStack {
            if columnSelected != nil {
                VStack(alignment: .leading) {
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
                        
                        Toggle("", isOn: $columns.columns[columnSelected!].hideColumn)
                            .frame(height: 20)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)).foregroundColor(.white)
                    )

                    
                    Picker("What is your favorite color?", selection: role) {
                        Text("Quantitative").tag(0)
                        Text("Nominal").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("What is your favorite color?", selection: type) {
                        Text("Text").tag(0)
                        Text("Number").tag(1)
                        Text("Date").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        if columns.columns[columnSelected!].type == ColumnType.number {
                            Text("Min: \(String(format: "%.2f", columns.columns[columnSelected!].min ?? 0))")
                            Text("Max: \(String(format: "%.2f", columns.columns[columnSelected!].max ?? 0))")
                            Text("Mean: \(String(format: "%.2f", columns.columns[columnSelected!].mean ?? 0))")
                            Text("Median: \(String(format: "%.2f", columns.columns[columnSelected!].median ?? 0))")
                        }
                        
                        Text("Invalid: \(columns.columns[columnSelected!].invalid ?? 0) (\(String(format: "%.2f", columns.columns[columnSelected!].invalidPercent ?? 0))%)")
                            .foregroundColor(.red)
                        
                        if let bins = columns.columns[columnSelected!].bins {
                            Divider()
                            
                            HStack(alignment: .bottom, spacing: 2) {
                                ForEach(bins.indices) { index in
                                    VStack(alignment: .leading) {
                                        VStack(spacing: 2) {
                                            Text("\(bins[index].1)")
                                                .font(.system(size: 8))
                                            
                                            Rectangle()
                                                .frame(width: 25, height: calculateBarHeight(bins: bins, index: index))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Text("\(String(format: "%.0f", bins[index].0.lowerBound))")
                                            .font(.system(size: 8))
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }.font(.caption)
                    
                    Spacer()
                }
                    .padding()
                    .frame(width: 300)
                    .frame(maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .foregroundColor(Color(hex: "#eee"))
                    )
                    .padding(.horizontal)
            }
        }
    }
    
    func calculateBarHeight(bins: [(Range<Double>, Int)], index: Int) -> CGFloat {
        (100.0 * CGFloat(bins[index].1)) / CGFloat(columns.columns[columnSelected!].maxBin ?? 1)
    }
}
