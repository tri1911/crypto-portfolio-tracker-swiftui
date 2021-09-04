//
//  UtilityViews.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-04.
//

import SwiftUI

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

//struct UtilityViews_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//    }
//}
