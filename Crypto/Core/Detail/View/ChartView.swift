//
//  ChartView.swift
//  Crypto
//
//  Created by forys on 2023-10-05.
//

import SwiftUI

struct ChartView: View {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    let startingDate: Date
    let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0 // let变量必须在init中初始化
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
        
    }
    
    var body: some View {
        VStack {
            chartView.frame(height: 200)
                .background(
                    VStack {
                        Divider()
                        Spacer()
                        Divider()
                        Spacer()
                        Divider()
                    }
                )
                .overlay(
                    VStack {
                        Text(maxY.formattedWithAbbreviations())
                        Spacer()
                        let price = (maxY + minY) / 2
                        Text(price.formattedWithAbbreviations())
                        Spacer()
                        Text(minY.formattedWithAbbreviations())
                    }.padding(.horizontal, 4)
                    , alignment: .leading
                    
                )
            HStack {
                Text(startingDate.asShortDate())
                Spacer()
                Text(endingDate.asShortDate())
            }.padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {percentage = 1.0}
            }
        }
       
        
        
    }
}

#Preview {
    ChartView(coin: DeveloperPreivew.instance.coin)
}

extension ChartView {
    
    private var chartView: some View {
        // geometry vs UIScreen
        GeometryReader { geo in
            Path {
                path in
                for index in data.indices {
                    let xPosition = geo.size.width / CGFloat(data.count)
                    * CGFloat(index + 1) // 每条数据的x坐标
                    //                let yPosotion = data.
                    
                    let yAxis = maxY - minY
                    
                    // iphone的0 在上面， 大的数字在下面 所以要减一下
                    let yPosition =  (1 - CGFloat((data[index] - minY)) / yAxis) * geo.size.height
                    
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x:xPosition, y:yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 10)
        }
    }
}
