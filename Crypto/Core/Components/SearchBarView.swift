//
//  SearchBarView.swift
//  Crypto
//
//  Created by forys on 2023-10-03.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String  // 使用binding从外部传入一个string
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?
                        Color.theme.secondaryText :
                        Color.theme.accent
                )
            TextField(
                "Search by name or symbol",
                text: $searchText
            )
            .disableAutocorrection(true)
            .foregroundColor(Color.theme.accent)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(
                        Color.theme.accent
                    )
                    .padding()
                    .offset(x:10)
                    .opacity(searchText.isEmpty ? 0.0 :1.0)
                    .onTapGesture {
                        // 删除内容 关闭输入法
                        UIApplication.shared.endEditing()
                        searchText = ""
                    },
                alignment: .trailing
                    
            )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10,
                    x: 0,
                    y: 0
                )
        )
        .padding() // 对background的padding
        
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
