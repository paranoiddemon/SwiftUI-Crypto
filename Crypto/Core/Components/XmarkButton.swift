//
//  XmarkButton.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import SwiftUI

struct XmarkButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
}

#Preview {
    XmarkButton()
}
