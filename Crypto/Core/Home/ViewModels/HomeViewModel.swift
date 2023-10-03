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
    
    private let dataService = CoinDataService()
    
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
        dataService.$allCoins // 使用$allCoins 表示一个subscriber service的数据变化会反应到当前的变量 并通知到view
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables) // & pass a reference
    }
    // The store(in:) method is part of the Combine framework in Swift. It is used to store the subscription of a publisher into a set of cancellables. The subscription will be automatically canceled (i.e., released) when the provided cancellable set is deallocated or explicitly canceled.
    
    // final public func store(in set: inout Set<AnyCancellable>)
}
