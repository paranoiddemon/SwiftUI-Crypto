//
//  PortfolioView.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, content: {
                    SearchBarView(searchText: $vm.searchText)
                    CoinLogoList
                    if selectedCoin != nil {
                        PortfolioInput
                    }
                })
            }
            .navigationTitle("Edit Portfolio")
            .toolbar (content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    // 如果抽象成xmark组件，environment 和sheet的不同， dismiss会出问题
                    Button {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        let time  = dateFormatter.string(from: Date())
                        print("dismiss: \(time)")
                        UIApplication.shared.endEditing()
                        dismiss() // 关闭sheet
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark")
                            .opacity(showCheckMark ? 1.0 : 0.0)
                        Button(
                            action: {
                                saveButtonPressed()
                            },
                            label: { Text("Save".uppercased()) }
                        )
                        .opacity(
                            (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText))
                            ? 1.0 : 0.0
                        )
                    }
                }
            }
            )
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(DeveloperPreivew.instance.homeVM)
}

extension PortfolioView {
    private func saveButtonPressed() {
        //guard let coin = selectedCoin else {return}
        
        // save
        
        withAnimation(.easeIn) {
            showCheckMark.toggle()
            // reset value
            selectedCoin = nil
            vm.searchText = ""
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        // Hide checkmark
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2.0,
            execute: {
                withAnimation(.easeOut) {
                    showCheckMark = false
                }
            }
        )
    }
    
    private func getCurrentValue() -> Double{
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var PortfolioInput: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""):" )
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount Holdings:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
            }
            Divider()
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var CoinLogoList:some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10, content: {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture(perform: {
                            withAnimation(.easeIn){
                                selectedCoin = coin
                            }
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            })
            .frame(height: 120)
            .padding(.leading)
        }
    }
}
