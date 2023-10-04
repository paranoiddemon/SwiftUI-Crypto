//
//  StatisticsVIew.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import SwiftUI

struct StatisticsView: View {  
    
    let stat: StatisticsModel
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 4,
               content: {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: stat.percentageChange ?? 0 >= 0 ? 0: 180))
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }.foregroundColor(stat.percentageChange ?? 0 >= 0 ? Color.theme.green : Color.theme.red )
                .opacity(stat.percentageChange == nil ? 0.0 : 1.0) // 如果没有就透明，但是占用的空间不变
        })
    }
}

#Preview {
    StatisticsView(stat: DeveloperPreivew.instance.stat1)
}
#Preview {
    StatisticsView(stat: DeveloperPreivew.instance.stat2)
}
#Preview {
    StatisticsView(stat: DeveloperPreivew.instance.stat3)
}


