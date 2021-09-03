//
//  HomeStatsView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-03.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject var store: HomeStore
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(store.statistics) {
                StatisticInfoView(stat: $0)
            }
        }
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView()
            .environmentObject(previewData.homeStore)
    }
}
