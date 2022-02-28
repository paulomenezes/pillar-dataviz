//
//  Columns.swift
//  Pillar
//
//  Created by Paulo Menezes on 28/02/22.
//

import Foundation

final class Columns: ObservableObject {
    @Published var columns: [Column]
    
    init(columns: [Column]) {
        self.columns = columns
    }
}
