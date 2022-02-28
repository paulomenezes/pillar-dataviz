//
//  Column.swift
//  Pillar
//
//  Created by Paulo Menezes on 28/02/22.
//

import Foundation
import SwiftUI

final class Column: ObservableObject {
    @Published var originalName: String
    @Published var name: String
    @Published var hideColumn: Bool
    @Published var role: ColumnRole
    @Published var type: ColumnType
    
    var min: Double?
    var max: Double?
    var mean: Double?
    var median: Double?
    var invalid: Int?
    var invalidPercent: Double?
    
    var bins: [(Range<Double>, Int)]?
    var maxBin: Int?
    
    init(originalName: String, name: String, hideColumn: Bool, role: ColumnRole, type: ColumnType) {
        self.originalName = originalName
        self.name = name
        self.hideColumn = hideColumn
        self.role = role
        self.type = type
    }
}

enum ColumnRole: Int {
    case quantitative = 0, nominal
}

enum ColumnType: Int {
    case text = 0, number, date
}
