//
//  HomeStatView.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import SwiftUI

struct HomeStatView: View {
    
    @EnvironmentObject private var vm : HomeViewModel
    @Binding var showPortfolio : Bool // 从外部传入的变量
    
    var body: some View {
        HStack {
            ForEach(vm.stats) {
                stat in
                StatisticsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
    }
}

#Preview {
    HomeStatView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreivew.instance.homeVM)
}
