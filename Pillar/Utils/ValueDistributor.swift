//
//  ValueDistributor.swift
//  Pillar
//
//  Created by Paulo Menezes on 28/02/22.
//

import Foundation

struct ValueDistributor {
    var dataArray: [Double]
    var numberOfBins: Int
    
    func feedBins() -> [(Range<Double>, Int)] {
        var collector: [(Range<Double>, Int)] = []
        if numberOfBins < 1 { return collector }
        let minValue = dataArray.min() ?? 0
        let maxValue = dataArray.max() ?? 0
        let maxValueForRange = maxValue + 0.000000000001 // to include maxValue in the top bin
        let binSize = (maxValue - minValue) / Double(numberOfBins)
        var binRanges: [Range<Double>] = []
        
        if numberOfBins == 1 {
            binRanges.append(minValue ..< maxValueForRange)
        } else {
            binRanges.append(minValue ..< minValue + binSize)
        }
        
        for binNum in 1..<numberOfBins {
            if let lastRange = binRanges.last {
                if binNum < numberOfBins - 1 {
                    binRanges.append(lastRange.upperBound ..< lastRange.upperBound + binSize)
                } else {
                    binRanges.append(lastRange.upperBound ..< maxValueForRange)
                }
            }
        }
        
        for r in binRanges {
            let countedRanges = dataArray.filter { r.contains($0) }
            collector.append((r, countedRanges.count))
        }
        
        let lastLower = collector[numberOfBins-1].0.lowerBound
        collector[numberOfBins-1].0 = lastLower ..< maxValue // Hide the artefact
        
        return collector
    }
    
}
