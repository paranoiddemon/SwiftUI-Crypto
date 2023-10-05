//
//  MarketDataService.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import Foundation
import Combine


class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil // 可以在viewModel中被订阅
    //    var cancellables = Set<AnyCancellable>()
    var marketDataSubsciption: AnyCancellable?
    
    init() {
        getData()
    }
    
    /*
     URL:
     
     */
    func getData() {
        
        // 为啥用guard  URL是个optional 如果不为nil才会继续， 构造函数：public init?(string: String)
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else { return }
        
        NetworkingManager
            .download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] globalData in // 弱引用，可以被de-allocation
                    self?.marketData = globalData.data // 使用？
                    self?.marketDataSubsciption?.cancel() // 取消订阅
                }
            )
        
    }
}
