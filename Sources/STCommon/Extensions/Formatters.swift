//
//  Formatters.swift
//  Misli.com
//
//  Created by ilyas Yavuz on 27.02.2020.
//  Copyright © 2020 Misli.com. All rights reserved.
//

import Foundation

private struct Formatter {
    fileprivate static func number(_ number: Any, isInteger: Bool = false) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "tr")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSeparator = ""

        if isInteger {
            numberFormatter.positiveFormat = "#.###,"
            numberFormatter.maximumFractionDigits = 0
        } else {
            numberFormatter.positiveFormat = "#.###,00"
            numberFormatter.maximumFractionDigits = 2
        }
        
        if let string = numberFormatter.string(for: number) {
            return string
        }
        return ""
    }
}

public extension Float {
    var string: String {
        return String(format: "%.2f", self)
    }
    var formattedString: String {
        return Formatter.number(self)
    }
    var integerString: String {
        return String(format: "%.f", self)
    }
    var floatString: String {
        return String(format: "%.1f", self)
    }
}

public extension Double {
    var string: String {
        return String(format: "%.2f", self)
    }
    var formattedString: String {
        return Formatter.number(self)
    }
}

public extension Decimal {
    var string: String {
        return Formatter.number(self)
    }
    var intValue: Int {
        return (self as NSDecimalNumber).intValue
    }
}
