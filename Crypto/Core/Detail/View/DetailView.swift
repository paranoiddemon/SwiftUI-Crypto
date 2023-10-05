//
//  DetailView.swift
//  Crypto
//
//  Created by forys on 2023-10-05.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
           ZStack {
               if let coin = coin {
                   DetailView(coin: coin)
               }
           }
       }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    @State private var showDesc: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 25
    
    // NavigationLink 不是lazy load的，会提前创建所有view
    init(coin: CoinModel) { // 传入一个binding变量， 外面的值变化会通知view
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Init Detail: \(coin.name)")
    }
    
    var body: some View {
        ScrollView {
            // Chart
            VStack {
                ChartView(coin: vm.coin)
                   .padding(.vertical)
            }
            VStack(spacing: 20) {
               
                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                
                // description
                ZStack {
                    if let desc = vm.desc, !desc.isEmpty {
                        VStack(alignment: .leading) {
                            Text(desc)
                                .lineLimit(showDesc ? nil : 3)
                                .font(.callout)
                                .foregroundColor(Color.theme.secondaryText)
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    print("button pressed")
                                    showDesc.toggle()
                                }
                            }, label: {
                                Text(showDesc ? "Less" :"Read More")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.vertical,4 )
                            })
                            .accentColor(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                            
                    }
                }
                
                // Overview
                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: spacing,
                    pinnedViews: [],
                    content: {
                        ForEach(vm.overviewStats) {
                            s in
                            StatisticsView(stat: s)
                        }
                    })
                
                
                // Addtional
                Text("Additional Details")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: spacing,
                    pinnedViews: [],
                    content: {
                        ForEach(vm.addtionalStats) {
                            s in
                           StatisticsView(stat: s)
                        }
                    }
                )
                
                // Website Link
                HStack() {
                    
                    if let website = vm.webURL,
                       let url = URL(string: website) {
                        Link("Website", destination: url)
                    }
                    
                    if let reddit = vm.redditURL,
                       let url = URL(string: reddit) {
                        Link("Reddit", destination: url)
                    }
                    Spacer()
                }.accentColor(.blue)
                    .font(.headline)
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(Color.theme.secondaryText)
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25, alignment: .center)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: DeveloperPreivew.instance.coin)
    }
}
