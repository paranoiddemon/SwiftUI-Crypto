//
//  CryptoApp.swift
//  Crypto
//
//  Created by forys on 2023-09-30.
//

import SwiftUI

@main
struct CryptoApp: App {
    // 需要定义一个StateObject
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
