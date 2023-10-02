//
//  CircleButtonView.swift
//  Crypto
//
//  Created by forys on 2023-09-30.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)// Define button view
            .font(.headline)
            .frame(width: 50, height: 50)
            .foregroundColor(Color.theme.accent)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.5),
                radius: 10, x: 0, y: 0
            )
    }
}

#Preview {
        CircleButtonView(iconName: "plus")
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
}

#Preview {
        CircleButtonView(iconName: "info")
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
}

    
