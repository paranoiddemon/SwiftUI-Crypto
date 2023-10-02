//
//  HomeView.swift
//  Crypto
//
//  Created by forys on 2023-09-30.
//

/* 
 
 Safe area in SwiftUI refers to the portion of the screen that is guaranteed to be visible and usable, regardless of the device size or orientation. It ensures that the content displayed within the safe area is not obstructed by things like the status bar, home indicator, or notch on modern iPhones.
 
 */

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                homeHeader
                List {
                    CoinRowView(
                        coin: DeveloperPreivew.instance.coin,
                        showHoldingColumn: true
                    )
                }
                .listStyle(PlainListStyle())
                Spacer(minLength: 0)
            }
        }
    }
}

extension HomeView {
    
    // use extention to add a variable in homeview
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" :"info")
                .animation(nil)
                .background(
                    CircleButtonAnimation(animate: $showPortfolio)
//                        .foregroundColor(.blue)
                        .frame(width: 70, height: 70)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" :"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        HomeView().navigationBarHidden(true)
    }
}
