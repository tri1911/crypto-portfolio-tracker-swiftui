//
//  ChartView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-05.
//

import SwiftUI

struct ChartView: View {
    let coin: CoinInfo
    
    // MARK: - Computed Properties
    
    private var data: [Double] { coin.sparklineIn7D?.price ?? [] }
    private var minY: Double { data.min() ?? 0 }
    private var maxY: Double { data.max() ?? 0 }
    private var lineColor: Color {
        guard let last = data.last, let first = data.first else { return .clear }
        return (last - first) >= 0 ? .theme.green : .theme.red
    }
    private var endDate: Date { coin.lastUpdated.toDate }
    private var startDate: Date { endDate.addingTimeInterval(-7*24*60*60) }
    
    var body: some View {
        VStack {
            chart
                .frame(height: 200)
                .overlay(chartLabels)
            dateLabels
        }
        .font(.caption)
        .foregroundColor(.theme.secondary)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.linear(duration: 2.0)) {
                    endFraction = 1.0
                }
            }
        }
    }
    
    @State private var endFraction: CGFloat = 0.0
    
    private var chart: some View {
        GeometryReader { geometry in
            Path { path in
                let xInterval = geometry.size.width / CGFloat(data.count - 1)
                let yInterval = geometry.size.height / CGFloat(maxY - minY)
                for index in data.indices {
                    let xCoordinate = CGFloat(index) * xInterval
                    let yCoordinate = geometry.size.height - CGFloat(data[index] - minY) * yInterval
                    if index == 0 {
                        path.move(to: CGPoint(x: xCoordinate, y: yCoordinate))
                    } else {
                        path.addLine(to: CGPoint(x: xCoordinate, y: yCoordinate))
                    }
                }
            }
            .trim(from: 0.0, to: endFraction)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 0.0)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20.0)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30.0)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40.0)
        }
    }
    
    private var chartLabels: some View {
        VStack(alignment: .leading, spacing: 4) {
            Divider()
            Text(maxY.formattedWithAbbreviations)
            Spacer()
            Text(((minY+maxY)/2).formattedWithAbbreviations)
            Divider()
            Spacer()
            Text(minY.formattedWithAbbreviations)
            Divider()
        }
    }
    
    private var dateLabels: some View {
        HStack {
            Text(startDate.toString)
            Spacer()
            Text(endDate.toString)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: previewData.coin)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
