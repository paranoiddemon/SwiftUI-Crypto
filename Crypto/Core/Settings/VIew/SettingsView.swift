//
//  Settings.swift
//  Crypto
//
//  Created by forys on 2023-10-05.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let coffeeURL = URL(string: "https://www.youtube.com")!
    let coingeckoURL = URL(string: "https://www.youtube.com")!
    let personalURL = URL(string: "https://www.youtube.com")!
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Swift Thinking")) {
                    HStack(){
                        Image("logo")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("This is a app made by following @SwiftfulThinking course on Youtube")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.theme.accent)
                            .padding(.horizontal)
                    }
                    Link("Subscribe on YouTube 🥰", destination: youtubeURL)
                        
                    Link("Buy me a coffee ☕️", destination: coffeeURL)
                }
                Section(header: Text("CoinGecko")) {
                    VStack(alignment:.leading){
                        Image("coingecko")
                            .resizable()
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("Free API to get coin Data")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.theme.accent)
                    }
                    .padding(.vertical)
                    Link("Visit CoinGecko 🥰", destination: youtubeURL)
                }
                
                Section(header: Text("Developer")) {
                    VStack(alignment:.leading){
                        Image("logo")
                            .resizable()
                            .frame(width:80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("Learn more")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.theme.accent)
                    }
                    .padding(.vertical)
                    Link("Visit Website 🥰", destination: youtubeURL)
                }
                Section(header: Text("Application")) {
                    Link("Terms of Service", destination: defaultURL)
                    Link("Privacy Policy", destination: defaultURL)
                    Link("Company Website", destination: defaultURL)
                    Link("Learn More", destination: defaultURL)
                }
                
  
                
            }
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss() // 关闭sheet
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
