//
//  String.swift
//  Pillar
//
//  Created by Paulo Menezes on 27/02/22.
//

import Foundation

extension String {
    var nsString: NSString { self as NSString }
    var length: Int { nsString.length }
    var nsRange: NSRange { .init(location: 0, length: length) }
    
    var detectDates: [Date]? {
        try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
                .matches(in: self, range: nsRange)
            .compactMap(\.date)
    }
    
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
