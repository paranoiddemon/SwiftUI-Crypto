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
    
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition((.move(edge: .leading)))
                    }
                }.zIndex(2.0) // move的时候不会被后面的遮挡
            }
        }
    }
}
