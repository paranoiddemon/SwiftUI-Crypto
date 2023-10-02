//
//  Color.swift
//  Crypto
//
//  Created by forys on 2023-09-30.
//

import Foundation
import SwiftUI

extension Color  {
    // access color through Color Extention
    // use static
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}
