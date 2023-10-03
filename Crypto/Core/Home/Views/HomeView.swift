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
    
    @EnvironmentObject private var vm: HomeViewModel // 变量名字要和外面传入的一样
    
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                homeHeader
                SearchBarView(searchText: $vm.searchText) // 使用$来bind变量到子view
                columnTitles
                if !showPortfolio {
                    allCoinList
                        .transition(.move(edge: .leading)) // 从左侧滑向右侧
                }
                if showPortfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                
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
                        showPortfolio.toggle() // 切换展示的页面
                    }
                }
            
        }
        .padding(.horizontal)
    }
    
    private var allCoinList: some View {
        List {
            ForEach(vm.allCoins) {
                coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 10,
                            bottom: 10,
                            trailing: 20
                        )
                    )
            }
            
        }
        .listStyle(
            PlainListStyle()
        )
    }
    
    private var portfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins) {
                coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 10,
                            bottom: 10,
                            trailing: 20
                        )
                    )
            }
            
        }
        .listStyle(
            PlainListStyle()
        )
    }
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

#Preview {
    
    NavigationView {
        HomeView().navigationBarHidden(true)
    }
    .environmentObject(DeveloperPreivew.instance.homeVM)
}
