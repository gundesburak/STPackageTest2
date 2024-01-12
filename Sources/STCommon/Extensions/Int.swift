//
//  Int.swift
//  Misli.com
//
//  Created by Erkan Demir on 16.12.2019.
//  Copyright © 2019 Misli.com. All rights reserved.
//

import Foundation

public extension Int {
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "")
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = "."
        return formatter.string(for: self) ?? ""
    }
    
    func string() -> String {
        return self.description
    }

    func getMilisecondsFromNow() -> (Int,Int,Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier:"AZ") as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateSellEndDate = Date(milliseconds: Int64(self))
        let dateNow = Date()
    
        let differenceInSeconds = Int(dateSellEndDate.timeIntervalSince(dateNow))
        return secondsToHoursMinutesSecondsFrom(Swift.max(differenceInSeconds,0))
    }
    
  
    private func secondsToHoursMinutesSecondsFrom(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
}
