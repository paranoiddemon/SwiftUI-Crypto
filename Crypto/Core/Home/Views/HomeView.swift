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
    
    @State private var showPortfolioView: Bool = false
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetail: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView() // new sheet是一个新的environment
                        .environmentObject(vm)
                })
            
            VStack {
                homeHeader
                HomeStatView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText) // 使用$来bind变量到子view
                columnTitles
                if !showPortfolio {
                    allCoinList
                        .transition(.move(edge: .leading)) // 从左侧滑向右侧
                        .refreshable {
                            vm.reloadData()
                        }
                }
                if showPortfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
        .background(
            // 懒加载 从创建选中的detailView
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetail,
                label: {EmptyView()}
            )
        )
    }
}

extension HomeView {
    
    // use extention to add a variable in homeview
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" :"info")
                .animation(nil)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle() // 一开始是false 点击后显示为true
                    }
                    print("add")
                }
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
                // NavigationLink 不是lazy load的，会提前创建所有view
//                NavigationLink (
//                     destination: DetailView(coin: coin),
//                     label: {
//                        CoinRowView(coin: coin, showHoldingColumn: false)
//                            .listRowInsets(
//                                .init(
//                                    top: 10,
//                                    leading: 10,
//                                    bottom: 10,
//                                    trailing: 20
//                                )
//                            )
//                           
//                })
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 10,
                            bottom: 10,
                            trailing: 20
                        )
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }


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
                    .onTapGesture {
                        segue(coin: coin)
                    }


            }
            
        }
        .listStyle(
            PlainListStyle()
        )
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetail.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        vm.sortOption == .rank || vm.sortOption == .rankReverserd
                             ? 1.0
                             : 0.0
                    )
                    .rotationEffect((Angle(degrees: vm.sortOption == .rank ? 0 : 180)))
            }
            .onTapGesture {
                withAnimation(.default){
                    if vm.sortOption == .rank {
                        vm.sortOption = .rankReverserd
                    } else {
                        vm.sortOption = .rank
                    }
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            vm.sortOption == .holdings || vm.sortOption == .holdingsReversed
                                 ? 1.0
                                 : 0.0
                        )
                        .rotationEffect((Angle(degrees: vm.sortOption == .holdings ? 0 : 180)))

                }
                .onTapGesture {
                    withAnimation(.default){
                        if vm.sortOption == .holdings {
                            vm.sortOption = .holdingsReversed
                        } else {
                            vm.sortOption = .holdings
                        }
                    }
                }

                
            }
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(
                        vm.sortOption == .price || vm.sortOption == .priceReversed
                             ? 1.0
                             : 0.0
                    )
                    .rotationEffect((Angle(degrees: vm.sortOption == .price ? 0 : 180)))

            }
            .onTapGesture {
                withAnimation(.default){
                    if vm.sortOption == .price {
                        vm.sortOption = .priceReversed
                    } else {
                        vm.sortOption = .price
                    }
                }
            }

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
