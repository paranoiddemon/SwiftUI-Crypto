//
//  CoinRowView.swift
//  Crypto
//
//  Created by forys on 2023-10-01.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingColumn: Bool
    
    var body: some View {
        HStack(spacing: 0){
            HStack(spacing: 0){
                Text("\(coin.rank)")
                   .font(.caption)
                   .foregroundColor(Color.theme.secondaryText)
                   .frame(minWidth: 30)
               CoinImageView(coin: coin)
                   .frame(width: 30, height: 30)
               Text(coin.symbol.uppercased())
                   .font(.headline)
                   .padding(.leading, 6)
                   .foregroundColor(Color.theme.accent)
            }
            Spacer()
            if showHoldingColumn {
                VStack(alignment: .trailing){
                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                    Text((coin.currentHoldings ?? 0).asNumberString())
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text("\(coin.priceChangePercentage24H?.asPercentString() ?? "")")
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 
                            ? Color.theme.green
                            : Color.theme.red
                        
                    )
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing) // 使用三分之一的宽度， 只有portrait mode，不然得使用GeometryReader
        }
        .font(.subheadline)
        .contentShape(Rectangle()) // 让整行都可以点击
    }
}

#Preview(traits: .sizeThatFitsLayout) { // 裁剪成size
    // 访问static变量 可以直接使用 .
    CoinRowView(coin: DeveloperPreivew.instance.coin, showHoldingColumn: true)
}
