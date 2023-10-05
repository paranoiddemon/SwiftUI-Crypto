//
//  DetailService.swift
//  Crypto
//
//  Created by forys on 2023-10-05.
//

import Foundation
import Combine

class CoinDetailService {
    
    @Published var detail: CoinDetailModel? = nil // 需要初始化
    
    var coinDetailSubsciption: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetail()
    }
    
    func getCoinDetail() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false" )
            else { return }
            
            NetworkingManager
                .download(url: url)
                .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
                .sink(
                    receiveCompletion: NetworkingManager.handleCompletion,
                    receiveValue: { [weak self] returnedDetail in // 弱引用，可以被de-allocation
                        self?.detail = returnedDetail // 使用？
                        self?.coinDetailSubsciption?.cancel() // 取消订阅
                    }
                )
            
        }
}
