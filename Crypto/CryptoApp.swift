//
//  CryptoApp.swift
//  Crypto
//
//  Created by forys on 2023-09-30.
//

import SwiftUI

@main
struct CryptoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
