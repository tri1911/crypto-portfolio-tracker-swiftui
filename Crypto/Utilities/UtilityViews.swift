//
//  UtilityViews.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-04.
//

import SwiftUI

struct AnimatedCircleButton: View {
    var imageName: String
    var action: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                action()
            }
        } label: {
            Image(systemName: imageName)
                .frame(width: 50, height: 50)
                .background(Color.theme.background)
                .clipShape(Circle())
                .shadow(color: .theme.accent, radius: 10, x: 0.0, y: 0.0)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(2)
                Text("Loading")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
            }
            Color.primary.opacity(0.05)
        }
        .frame(width: 150, height: 150)
        .cornerRadius(15.0)
    }
}

struct CircleAnimationView: View {
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeOut(duration: 1.0) : .none)
    }
}

//struct UtilityViews_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//        CircleAnimationView(animate: .constant(false))
//            .foregroundColor(.green)
//            .frame(width: 100, height: 100)
//    }
//}
