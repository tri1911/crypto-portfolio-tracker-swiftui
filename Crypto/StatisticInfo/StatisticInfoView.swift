//
//  StatisticInfoView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct StatisticInfoView: View {
    let stat: StatisticInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stat.title)
            Text(stat.value)
            Text(stat.changePercentage?.asPercentString ?? "")
        }
    }
}

struct StatisticInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticInfoView(stat: previewData.stat1)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        StatisticInfoView(stat: previewData.stat2)
            .previewLayout(.sizeThatFits)
        StatisticInfoView(stat: previewData.stat3)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
