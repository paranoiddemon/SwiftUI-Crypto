//
//  CircleButtonAnimation.swift
//  Crypto
//
//  Created by forys on 2023-09-30.
//

import SwiftUI

struct CircleButtonAnimation: View {
    @Binding var animate: Bool
//    @State var animate: Bool = false
        
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
//            .foregroundColor(.blue)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)// 逐渐消失
            .animation(animate ? Animation.easeOut(duration: 1.0): nil)
//            .onAppear{
//                animate.toggle()
//            }
            
    }
}

#Preview {
    CircleButtonAnimation(animate: .constant(false))
        .foregroundColor(.red)
        .frame(width: 100, height: 100)
}
