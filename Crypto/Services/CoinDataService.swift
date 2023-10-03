//
//  CoinDataService.swift
//  Crypto
//
//  Created by forys on 2023-10-02.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = [] // 可以在viewModel中被订阅
    //    var cancellables = Set<AnyCancellable>()
    var coinSubsciption: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    /*
     URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
     
     */
    private func getCoins() {
        
        // 为啥用guard  URL是个optional 如果不为nil才会继续， 构造函数：public init?(string: String)
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }
        
        NetworkingManager
            .download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] returnedCoins in // 弱引用，可以被de-allocation
                    self?.allCoins = returnedCoins // 使用？
                    self?.coinSubsciption?.cancel() // 取消订阅
                }
            )
        
    }
    
    
}
