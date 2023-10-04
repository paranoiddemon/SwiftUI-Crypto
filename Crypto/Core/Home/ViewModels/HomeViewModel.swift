//
//  HomeViewModel.swift
//  Crypto
//
//  Created by forys on 2023-10-02.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    static var stat1 = StatisticsModel(title:"Market Cap", value: "$12.25Bn", percentageChange: 25.24)
    static var stat2 = StatisticsModel(title:"Total Volumn", value: "$1.23Tr")
    static var stat3 = StatisticsModel(title:"Portfolio Value", value: "$50.4k", percentageChange: -15.31)
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    @Published var stats: [StatisticsModel] = [
        StatisticsModel(title:"Market Cap", value: "$12.25Bn", percentageChange: 25.24),
        StatisticsModel(title:"Total Volumn", value: "$1.23Tr"),
        StatisticsModel(title:"Portfolio Value", value: "$50.4k", percentageChange: -15.31)
    ]
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    
    // https://swift.gg/2018/07/16/friday-qa-2015-07-17-when-to-use-swift-structs-and-classes/
    private var cancellables = Set<AnyCancellable>() // 初始化一个cancel的集合
    // Set是struct ，AnyCancellable是class
    // the collection cancellables must be declared with the var keyword to be mutable, allowing modifications to be made to it inside the method.
    
    
    
    init() {
        //        DispatchQueue.main.asyncAfter(
        //            deadline: .now() + 2.0 ,
        //            execute: {
        //                self.allCoins.append(DeveloperPreivew.instance.coin)
        //                self.allCoins.append(DeveloperPreivew.instance.coin)
        //                self.portfolioCoins.append(DeveloperPreivew.instance.coin)
        //            }
        //        )
        addSubscribers()
    }
    
    func addSubscribers(){
        //        dataService.$allCoins // 使用$allCoins 表示一个subscriber service的数据变化会反应到当前的变量 并通知到view
        //            .sink { [weak self] (returnedCoins) in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables) // & pass a reference
        
        $searchText
            .combineLatest(coinDataService.$allCoins) // 绑定到已有的subscriber
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // 类似js的debounce
            .map {(text, startingCoins) -> [CoinModel] in // filter也可以抽出来
                guard !text.isEmpty else {
                    return startingCoins
                }
                let lowercasedText = text.lowercased()
                return startingCoins.filter { coin -> Bool in
                    return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins // 返回过滤的结果 赋值给过滤后的结果
            } // 返回两个publisher.out  分别是searchText 和 allCoins
            .store(in: &cancellables) // 取消订阅
        
        marketDataService.$marketData
            .map { marketData -> [StatisticsModel] in
                var stats: [StatisticsModel] = []
                guard let data = marketData else {
                    return stats
                }
                
                let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volumn = StatisticsModel(title: "24h Volumn", value: data.volumn)
                let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
                let portfolio = StatisticsModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0 )
                
                stats.append(contentsOf: [marketCap, volumn, btcDominance, portfolio])
                return stats
            }
            .sink { [weak self] returnedStats in
                self?.stats = returnedStats
            }
            .store(in: &cancellables)
    }
    // The store(in:) method is part of the Combine framework in Swift. It is used to store the subscription of a publisher into a set of cancellables. The subscription will be automatically canceled (i.e., released) when the provided cancellable set is deallocated or explicitly canceled.
    
    // final public func store(in set: inout Set<AnyCancellable>)
    
}
