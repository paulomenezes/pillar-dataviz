//
//  String.swift
//  Pillar
//
//  Created by Paulo Menezes on 27/02/22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    var isNumeric : Bool {
        return Double(self) != nil
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
