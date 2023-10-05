//
//  DetailViewModel.swift
//  Crypto
//
//  Created by forys on 2023-10-05.
//

import Foundation
import SwiftUI
import Combine


class DetailViewModel: ObservableObject {
    
    private let coinDetainService: CoinDetailService
    private var cancellable = Set<AnyCancellable>()
    
    @Published var coin: CoinModel
    
    @Published var overviewStats: [StatisticsModel] = []
    @Published var addtionalStats: [StatisticsModel] = []
    
    @Published var desc : String? = nil
    @Published var webURL : String? = nil
    @Published var redditURL : String? = nil
    
    init(coin: CoinModel){
        self.coin = coin
        self.coinDetainService = CoinDetailService(coin: coin)
        addSubscribers()
    }

    private func addSubscribers(){
        coinDetainService.$detail
            .combineLatest($coin)
            .map(mapDataToStat)
            .sink { [weak self] returnedTuple in
                self?.overviewStats = returnedTuple.overview
                self?.addtionalStats = returnedTuple.addtional
            }
            .store(in: &cancellable)
        
        coinDetainService.$detail
            .sink { [weak self] coinDetail in
                self?.desc  = coinDetail?.readableDescription
                self?.webURL  = coinDetail?.links?.homepage?.first
                self?.redditURL  = coinDetail?.links?.subredditURL
            }
            .store(in: &cancellable)
    }
    
    // CoinDetail定义的时候设置了可能为空
    private func mapDataToStat(coinDetail: CoinDetailModel?, coin:CoinModel) -> (overview: [StatisticsModel], addtional: [StatisticsModel]) {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePerChange = coin.priceChangePercentage24H
        
        let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChange: pricePerChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticsModel(title: "Market Cap", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coin.rank)"
        let rankStat = StatisticsModel(title: "Rank", value: rank)
        let volumn = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumnStat = StatisticsModel(title: "Volumn", value: volumn)
        
        let overView : [StatisticsModel] = [priceStat, marketCapStat, rankStat, volumnStat]
        
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticsModel(title: "24H High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticsModel(title: "24H Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePerChange2 = coin.priceChangePercentage24H
        let priceStat2 = StatisticsModel(title: "24H Price Change", value: priceChange, percentageChange: pricePerChange2)
        
        let marketChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "n/a")
        let markPerChange = coin.marketCapChangePercentage24H
        let marketCapStat2 = StatisticsModel(title: "24 Market Cap Change", value: marketChange, percentageChange: markPerChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticsModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticsModel(title: "Hasing Algorithm", value: hashing)
        
        let addtional : [StatisticsModel] = [highStat, lowStat, priceStat2, marketCapStat2, blockTimeStat ,hashingStat]
        return (overView, addtional)
    }
}
