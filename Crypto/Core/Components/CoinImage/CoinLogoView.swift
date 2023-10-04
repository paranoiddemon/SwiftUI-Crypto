//
//  CoinLogoView.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: CoinModel
    
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            /*
             Let's go through each modifier used in the provided code:

             1. `.font(.caption)`: Sets the font style for the text to `.caption`. The `.caption` style is a small font size typically used for captions or small text.
             2. `.foregroundColor(Color.theme.secondaryText)`: Changes the text color to the `secondaryText` color from the `theme` color scheme. This modifier sets the text color to a specific predefined color.
             3. `.lineLimit(2)`: Sets the maximum number of lines the text can occupy to 2. If the content exceeds this limit, it will be truncated.
             4. `.minimumScaleFactor(0.5)`: Specifies the minimum amount the font can be scaled down to fit into the available space. In this case, the text can shrink to a minimum of 50% of its original size.
             5. `.multilineTextAlignment(.center)`: Aligns the text content to the center of the view, allowing for multiple lines of text if needed.

             These modifiers help customize the appearance of the `Text` view.
             */
        }
    }
}

#Preview {
    CoinLogoView(coin: DeveloperPreivew.instance.coin)
        
}
