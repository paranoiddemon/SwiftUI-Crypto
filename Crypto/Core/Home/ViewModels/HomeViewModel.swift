//
//  HomeViewModel.swift
//  Crypto
//
//  Created by forys on 2023-10-02.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var stats: [StatisticsModel] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>() // 初始化一个cancel的集合

    
    init() {
        addSubscribers()
    }
    
    func addSubscribers(){
        //        dataService.$allCoins // 使用$allCoins 表示一个subscriber service的数据变化会反应到当前的变量 并通知到view
        //            .sink { [weak self] (returnedCoins) in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables) // & pass a reference
        
        // all coins
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
        
        // market data
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
                self?.stats = returnedStats // 这里不是append的
            }
            .store(in: &cancellables)
        
        // portfolio coins
        $allCoins // allCoin是一个subsciber 然后combine一个subscriber，因为存储的是coin中的holdings属性和id
            .combineLatest(portfolioService.$savedEntities)
            .map{
                (coins, portfolios) -> [CoinModel] in
                // coins是[CoinModel]，portfolios是[PortfolioEntity]
                // 使用每一个coin取匹配portfolios， 找到后则更新coin
                coins.compactMap { coin -> CoinModel? in
                    guard let entity = portfolios.first(where: {$0.coinID == coin.id}) else {
                        return nil
                    }
                    //print(entity)
                    return coin.updateHoldings(amount: entity.amount) // 从entity中取回amount 绑定到coin上
                }
            }
            .sink { [weak self] (returnedCoins) in
                //print(returnedCoins)
                self?.portfolioCoins = returnedCoins // portfolioCoins也是CoinModel类型，只是多了holding这个值
            }
            .store(in: &cancellables) // 一定要调用这个store否则 会出问题
    }
    
    // 当用户存储数据的时候调用。存储完之后，就被前面的订阅更新到view中
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioService.updatePortfolio(coin: coin, amount: amount)
    }
   
    
}
