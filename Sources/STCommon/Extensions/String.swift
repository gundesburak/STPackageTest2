//
//  String.swift
//  Misli.com
//
//  Created by Erkan Demir on 22.11.2019.
//  Copyright © 2019 Misli.com. All rights reserved.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    var intValue: Int {
        return (self as NSString).integerValue
    }
    
    func digits() -> String {
        replacingOccurrences(of: "\\D+", with: "", options: .regularExpression, range: nil)
    }
    
    func phone() -> String {
        return digits().replacingOccurrences(of: "^0", with: "", options: .regularExpression, range: nil)
    }
    
    /// Handles 10 or 11 digit phone numbers
    ///
    /// - Returns: formatted phone number or original value
    func toPhoneNumber() -> String {
        let digits = self.digitsOnly
        if digits.count == 10 {
            return digits.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{2})(\\d+)", with: "0 $1 $2 $3 $4", options: .regularExpression, range: nil)
        } else if digits.count == 11 {
            return digits.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d{2})(\\d+)",
                                               with: "$1 $2 $3 $4 $5", options: .regularExpression, range: nil)
        } else {
            return self
        }
    }
    
    func convertToPhone() -> String {
        var phoneNumber = self.replacingOccurrences(of: "0 (", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        return phoneNumber
    }
    
    func getQueryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: self) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    /// search turkish characters
    func contains(string search: String, caseSensitive: Bool) -> Bool {
        guard let regex = search.turkishRegex(caseSensitive: caseSensitive) else {
            return false
        }
        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        return !results.isEmpty
    }
    
    func turkishRegex(caseSensitive: Bool) -> NSRegularExpression? {
        do {
            // s i o c g u
            var regexPattern = ""
            var regexCharacter = ""
            for character in self {
                regexCharacter = ""
                if character == "I" || character == "İ" || character == "ı" || character == "i" {
                    regexCharacter = "[Iİıi]"
                } else if character == "S" || character == "Ş" || character == "s" || character == "ş" {
                    regexCharacter = "[SŞsş]"
                } else if character == "O" || character == "Ö" || character == "o" || character == "ö" {
                    regexCharacter = "[OÖoö]"
                } else if character == "C" || character == "Ç" || character == "c" || character == "ç" {
                    regexCharacter = "[CÇcç]"
                } else if character == "G" || character == "Ğ" || character == "g" || character == "ğ" {
                    regexCharacter = "[GĞgğ]"
                } else if character == "U" || character == "Ü" || character == "u" || character == "ü" {
                    regexCharacter = "[UÜuü]"
                } else {
                    regexCharacter = "\(character)"
                }
                regexPattern += regexCharacter
            }
            
            let options: NSRegularExpression.Options = caseSensitive ? [] : [.caseInsensitive]
            
            return try NSRegularExpression(pattern: regexPattern, options: options)
        } catch {
            return nil
        }
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
    
    func format(restricts: CharacterSet?, masked: String?) -> String? {
        guard let mask = masked else {
            return self
        }
        var rawString = self
        
        if let restricts = restricts {
            rawString = rawString.filter { (char) -> Bool in
                char.unicodeScalars.contains {
                    restricts.contains($0)
                }
            }
        }
        
        var formatted = ""
        var index = rawString.startIndex
        
        for char in mask {
            if index == rawString.endIndex {
                return formatted
            }
            
            if char == "#" {
                formatted.append(rawString[index])
                index = rawString.index(after: index)
            } else {
                formatted.append(char)
                
                if char == rawString[index] {
                    index = rawString.index(after: index)
                }
            }
        }
        
        return formatted
    }

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
    
    func validatePhoneNumber() -> Bool {
        if self.count > 2 {
            if self.prefix(4) == "(027" ||
                self.prefix(4) == "(040" ||
                self.prefix(4) == "(044" ||
                self.prefix(4) == "(050" ||
                self.prefix(4) == "(051" ||
                self.prefix(4) == "(055" ||
                self.prefix(4) == "(060" ||
                self.prefix(4) == "(070" ||
                self.prefix(4) == "(077" ||
                self.prefix(4) == "(099" ||
                self.prefix(4) == "(010" {
                return true
            } else {
                return false
            }
        }
        return false
    }
}

public extension StringProtocol {
    /// Returns the string with only [0-9], all other characters are filtered out
    var digitsOnly: String {
        String(filter(("0"..."9").contains))
    }
}
