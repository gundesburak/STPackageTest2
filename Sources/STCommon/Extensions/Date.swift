//
//  Date.swift
//  Misli.com
//
//  Created by ilyas Yavuz on 10.02.2020.
//  Copyright © 2020 Misli.com. All rights reserved.
//

import UIKit

public extension Date {
    static func - (lhs: Date, rhs: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: rhs, to: lhs).day ?? 0
    }
    
    func prettyDay(formatter: DateFormatter) -> String {
        if Calendar.current.isDateInToday(self) {
            return "Bu Gün"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "Sabah"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Dün"
        } else {
            return formatter.string(from: self)
        }
    }
    
    func prettyDayHour(formatter: DateFormatter) -> String {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        if Calendar.current.isDateInToday(self) {
            return "Bu Gün \(hourFormatter.string(from: self))"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "Sabah \(hourFormatter.string(from: self))"
        } else {
            return formatter.string(from: self)
        }
    }

    func remaining() -> String {
        var titles = [String]()
        let units: Set<Calendar.Component> = [.day, .hour, .minute]
        let components = Calendar.current.dateComponents(units, from: Date(), to: self)
        if let value = components.day, value > 0 {
            titles.append("\(value) Gün")
        }
        if let value = components.hour, value > 0 {
            titles.append("\(value) Saat")
        }
        if let value = components.minute, value > 0 {
            titles.append("\(value) Dəqiqə")
        }
        return titles.joined(separator: " ")
    }
    
    func timeAgoSinceDate() -> String {
        let toDate = Date()
        
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: self, to: toDate).year, interval > 0 {
            return "\(interval)" + " " + "yıl önce"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: self, to: toDate).month, interval > 0 {
            return "\(interval)" + " " + "ay önce"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: self, to: toDate).day, interval > 0 {
            return "\(interval)" + " " + "gün önce"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: self, to: toDate).hour, interval > 0 {
            return "\(interval)" + " " + "saat önce"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: self, to: toDate).minute, interval > 0 {
            return "\(interval)" + " " + "dəqiqə önce"
        }

        return "Az önce"
    }
}

public extension Date{
    func toString(format: String = "MMM dd, EEEE") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    func toString( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func isTimeUp(interval: TimeInterval) -> Bool {
        return self.addingTimeInterval(interval) < Date()
    }
}

public extension Date {
    init(dateTime: (UInt16, UInt16)) {
        var msdosDateTime = Int(dateTime.0)
        msdosDateTime <<= 16
        msdosDateTime |= Int(dateTime.1)
        var unixTime = tm()
        unixTime.tm_sec = Int32((msdosDateTime&31)*2)
        unixTime.tm_min = Int32((msdosDateTime>>5)&63)
        unixTime.tm_hour = Int32((Int(dateTime.1)>>11)&31)
        unixTime.tm_mday = Int32((msdosDateTime>>16)&31)
        unixTime.tm_mon = Int32((msdosDateTime>>21)&15)
        unixTime.tm_mon -= 1 // UNIX time struct month entries are zero based.
        unixTime.tm_year = Int32(1980+(msdosDateTime>>25))
        unixTime.tm_year -= 1900 // UNIX time structs count in "years since 1900".
        let time = timegm(&unixTime)
        self = Date(timeIntervalSince1970: TimeInterval(time))
    }

    var fileModificationDateTime: (UInt16, UInt16) {
        return (self.fileModificationDate, self.fileModificationTime)
    }

    var fileModificationDate: UInt16 {
        var time = time_t(self.timeIntervalSince1970)
        guard let unixTime = gmtime(&time) else {
            return 0
        }
        var year = unixTime.pointee.tm_year + 1900 // UNIX time structs count in "years since 1900".
        // ZIP uses the MSDOS date format which has a valid range of 1980 - 2099.
        year = year >= 1980 ? year : 1980
        year = year <= 2099 ? year : 2099
        let month = unixTime.pointee.tm_mon + 1 // UNIX time struct month entries are zero based.
        let day = unixTime.pointee.tm_mday
        return (UInt16)(day + ((month) * 32) +  ((year - 1980) * 512))
    }

    var fileModificationTime: UInt16 {
        var time = time_t(self.timeIntervalSince1970)
        guard let unixTime = gmtime(&time) else {
            return 0
        }
        let hour = unixTime.pointee.tm_hour
        let minute = unixTime.pointee.tm_min
        let second = unixTime.pointee.tm_sec
        return (UInt16)((second/2) + (minute * 32) + (hour * 2048))
    }
}


public extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

public extension Date {

    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }

    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }

}
