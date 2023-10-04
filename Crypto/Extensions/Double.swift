//
//  Double.swift
//  Crypto
//
//  Created by forys on 2023-10-01.
//

import Foundation

extension Double{
    
    // Option + click : view API doc
    
    ///Convert Double to Currency
    ///```
    ///Convert 1234.56 to $ 1234.56
    ///```
    private var ccyFormatter2: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //        formatter.locale = .current
        //        formatter.currencyCode = "usd"
        //        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    ///Convert Double to Currency
    ///```
    ///Convert 1234.56 to $ “1234.56”
    ///```
    func asCurrencyWith2Decimals() -> String {
        // 传入的是Double自身的引用， 转成NSNumber 把swift的值类型转换成引用类型
        // It bridges between Swift's value types and Objective-C's reference types.
        
        let number = NSNumber(value: self)
        return ccyFormatter2.string(from: number) ?? "$0.00" // formatter的API：从NSNumber转换成String
    }
    
    
    // Option + click : view API doc
    
    ///Convert Double to Currency
    ///```
    ///Convert 1234.56 to $ 1234.56
    ///Convert 12.3456 to $ 12.3456
    ///```
    private var ccyFormatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //        formatter.locale = .current
        //        formatter.currencyCode = "usd"
        //        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    // 可以直接在double值上调用
    ///Convert Double to Currency
    ///```
    ///Convert 1234.56 to $ “1234.56”
    ///Convert 12.3456 to $ ”12.3456“
    ///```
    func asCurrencyWith6Decimals() -> String {
        // 传入的是Double自身的引用， 转成NSNumber 把swift的值类型转换成引用类型
        // It bridges between Swift's value types and Objective-C's reference types.
        
        let number = NSNumber(value: self)
        return ccyFormatter.string(from: number) ?? "$0.00" // formatter的API：从NSNumber转换成String
    }
    
    func asNumberString() -> String {
        return String(format: "%.2f", self) // 保留两位小数
    }
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()
            
        default:
            return "\(sign)\(self)"
        }
    }
}
