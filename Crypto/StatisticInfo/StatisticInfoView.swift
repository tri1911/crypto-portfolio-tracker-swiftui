//
//  StatisticInfoView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct StatisticInfoView: View {
    let stat: StatisticInfo
    
    private var isPositiveChange: Bool { (stat.changePercentage ?? 0) >= 0  }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondary)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            HStack(spacing: 3) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: isPositiveChange ? 0 : 180))
                Text(stat.changePercentage?.asPercentString ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(isPositiveChange ? .theme.green : .red)
            .opacity(stat.changePercentage != nil ? 1 : 0)
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
