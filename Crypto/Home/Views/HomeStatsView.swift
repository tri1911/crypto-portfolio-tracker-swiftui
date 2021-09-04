//
//  HomeStatsView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-03.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject var store: HomeStore
    @Binding var showsPortfolio: Bool
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(store.statistics) {
                StatisticInfoView(stat: $0)
                    .frame(width: screenWidth / 3)
            }
        }
        .frame(width: screenWidth, alignment: showsPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showsPortfolio: .constant(true))
            .environmentObject(previewData.homeStore)
    }
}
