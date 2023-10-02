//
//  ContentView.swift
//  Crypto
//
//  Created by forys on 2023-09-30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Text("test").foregroundColor(Color.theme.accent)
                Text("test").foregroundColor(Color.theme.secondaryText)
                Text("test").foregroundColor(Color.theme.red)
                Text("test").foregroundColor(Color.theme.green)
            }
            .font(.headline)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .preferredColorScheme(.light)
    ContentView()
      .preferredColorScheme(.dark)
  }
}
