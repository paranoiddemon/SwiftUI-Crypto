//
//  CoinImageView.swift
//  Crypto
//
//  Created by forys on 2023-10-03.
//

import SwiftUI



struct CoinImageView: View {
   
    
    @StateObject var vm: CoinImageViewModel
    
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
        // Cannot assign to property: 'vm' is a get-only property
        // 如果要在init中初始化 必须包装成 StateObject
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView() // SwiftUI内置的加载UI
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreivew.instance.coin)
}
