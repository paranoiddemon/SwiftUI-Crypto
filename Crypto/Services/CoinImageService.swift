//
//  CoinImageService.swift
//  Crypto
//
//  Created by forys on 2023-10-03.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    
    private let coin: CoinModel
    
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        // 先从本地缓存获取
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
        
    }
    
    private func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) // 直接从全局变量中取
        else { return }
        
        NetworkingManager
            .download(url: url)
            .tryMap({data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: {
                    [weak self] returnIamge in // 弱引用，可以被de-allocation
                    guard let self = self, let downloadedImage = returnIamge else {return} // 对return image做了解包， 否则trymap得到的是UIImage? 而参数需要的是UIImage
                    self.image = downloadedImage // 使用？
                    self.imageSubscription?.cancel() // 取消订阅
                    self.fileManager.saveIamge( // 在闭包中设置时必须使用self.,使闭包中的捕获语义清晰
                        image: downloadedImage,
                        imageName: self.imageName,
                        folderName: self.folderName
                    )
                }
            )
        
    }
}
