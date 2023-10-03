//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by forys on 2023-10-03.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    // 在viewModel中调用service 获取数据， 当viewmodel中的数据更新会 会通知view
    private let dataService: CoinImageService
    
    private let coin: CoinModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin) // 传入imageService 然后去一个url获取图片
        addSubscribers()
        self.isLoading = true
        
    }
    
    private func addSubscribers(){ // ViewModel 的作用就是给viewmodel中的变量 image绑定监听，会publish到view中
        dataService.$image
            .sink { [weak self](_) in
                self?.isLoading = false // 当订阅完成时 不再是loading
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage // 处理返回值
            }
            .store(in: &cancellables) // 取消订阅

        
    }
}
