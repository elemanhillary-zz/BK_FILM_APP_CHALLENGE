//
//  String+.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import Foundation
import UIKit

extension String {
    static func formatCount(count:NSInteger) -> String {
        let num = abs(Double(count))
        let sign = (count < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"
            
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"
            
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"
            
        case 0...:
            return "\(count)"
            
        default:
            return "0"
        }
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}
