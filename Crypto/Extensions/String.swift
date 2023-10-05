//
//  String.swift
//  Crypto
//
//  Created by forys on 2023-10-05.
//

import Foundation

extension String {
    
    var removeHTML: String {
        return self.replacingOccurrences(of: "<[^>]+>", with:"", options: .regularExpression, range: nil)
    }
}
