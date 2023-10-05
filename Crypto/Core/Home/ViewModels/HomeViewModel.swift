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
    @Published var isLoading: Bool = false
    
    @Published var sortOption: SortOption = .holdings // 默认排序
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>() // 初始化一个cancel的集合
    
    enum SortOption {
        case rank, rankReverserd, holdings, holdingsReversed, price, priceReversed
        
    }
    
     
    init() {
        addSubscribers()
    }
    
    
    
    func addSubscribers(){
        subscribeCoins()
        subscribePortfolio()
        subscrbeMarketData()
    }
    
    private func subscribeCoins() {
        $searchText // 使用$allCoins 表示一个subscriber service的数据变化会反应到当前的变量 并通知到view
            .combineLatest(coinDataService.$allCoins, $sortOption) // 绑定到已有的subscriber
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // 类似js的debounce
            .map {(text, coins, sortOption) -> [CoinModel] in // 传入的变量是不可变的，如果要变需要copy到新的var
                var filteredCoins = self.filterCoins(text: text, startingCoins: coins)
                // sort 是在原地sort 可以用inout传递引用， sorted返回新的数组
                self.sortCoins(coins: &filteredCoins, sortOption: sortOption) // 闭包要写self
                return filteredCoins
            }
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins // 返回过滤的结果 赋值给过滤后的结果
            } // 返回两个publisher.out  分别是searchText 和 allCoins
            .store(in: &cancellables) // 取消订阅
    }
    
    private func subscribePortfolio() {
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
                guard let self = self else {return}
                // 对portfolio页面过滤
                self.portfolioCoins = self.sortPortfolio(coins: returnedCoins)  // portfolioCoins也是CoinModel类型，只是多了holding这个值
            }
            .store(in: &cancellables) // 一定要调用这个store否则 会出问题
    }
    
    private func subscrbeMarketData() {
        // market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins) //  Publishers
            .map { marketData, portfolioCoins -> [StatisticsModel] in
                var stats: [StatisticsModel] = []
                guard let data = marketData else {
                    return stats
                }
                
                let portfolioValue = portfolioCoins
                    .map {
                        coin -> Double in
                        return coin.currentHoldingsValue // model里有computed properties
                    }
                    .reduce(0, +) // 加总
                
                let previousValue =
                portfolioCoins
                    .map { (coin) -> Double in
                        let currentValue = coin.currentHoldingsValue
                        let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                        let previousValue = currentValue / (1 + percentChange)
                        return previousValue
                    }
                    .reduce(0, +)
                
                let percentageChange = ((portfolioValue - previousValue) / previousValue)
                
                let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volumn = StatisticsModel(title: "24h Volumn", value: data.volumn)
                let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
                let portfolio = StatisticsModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange )
                
                stats.append(contentsOf: [marketCap, volumn, btcDominance, portfolio])
                return stats
            }
            .sink { [weak self] returnedStats in
                self?.stats = returnedStats // 这里不是append的
                self?.isLoading = false // 当整个订阅结束 重新赋值为false
            }
            .store(in: &cancellables)
    }
    
    
    private func sortPortfolio(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings: return coins.sorted{$0.currentHoldingsValue > $1.currentHoldingsValue}
        case .holdingsReversed: return coins.sorted{$0.currentHoldingsValue < $1.currentHoldingsValue}
        default: return coins
        }
    }
    
    private func sortCoins(coins: inout [CoinModel], sortOption: SortOption ){
        switch sortOption {
            case .rank, .holdings: coins.sort{$0.rank < $1.rank}
            case .rankReverserd, .holdingsReversed: coins.sort{$0.rank > $1.rank}
            case .price: coins.sort{$0.currentPrice < $1.currentPrice}
            case .priceReversed: coins.sort{$0.currentPrice > $1.currentPrice}
        }
    }
    
    private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {// filter也可以抽出来
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
    
    // 当用户存储数据的时候调用。存储完之后，就被前面的订阅更新到view中
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioService.updatePortfolio(coin: coin, amount: amount)
    }
    
    // 刷新数据
    func reloadData(){
        isLoading = true
        print("reload called")
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    
}
