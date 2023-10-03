//
//  UIApplication.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
