//
//  CoinDetailsView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-04.
//

import SwiftUI

struct CoinDetailsView: View {
    @StateObject var store: CoinDetailsStore
    
    private let columns = Array(repeating: GridItem(), count: 2)
    private let spacing: CGFloat = 30
    
    init(_ info: CoinInfo) {
        _store = .init(wrappedValue: CoinDetailsStore(info))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ChartView(coin: store.coinInfo).padding(.vertical)
                overview
                additional
                links
            }
            .padding(.horizontal)
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(store.coinInfo.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(store.coinInfo.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(.theme.secondary)
                    CoinImageView(store.coinInfo)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
    
    private var overview: some View {
        VStack {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            description
            LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
                ForEach(store.overviewStats) { stat in
                    StatisticInfoView(stat: stat)
                }
            }
        }
    }
    
    @State private var showsFullDescription = false
    
    private var description: some View {
        VStack(alignment: .leading) {
            Text(store.description)
                .lineLimit(showsFullDescription ? nil : 3)
                .font(.callout)
                .foregroundColor(.theme.secondary)
            Button {
                withAnimation {
                    showsFullDescription.toggle()
                }
            } label: {
                Text(showsFullDescription ? "Less" : "Read More...")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.vertical)
            }
            .accentColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additional: some View {
        VStack {
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundColor(.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
                ForEach(store.additionalStats) { stat in
                    StatisticInfoView(stat: stat)
                }
            }
        }
    }
    
    private var links: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let homePage = store.homepage, let url = URL(string: homePage) {
                Link("HomePage", destination: url)
            }
            if let subreddit = store.subredditURL, let url = URL(string: subreddit) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CoinDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailsView(previewData.coin)
            .preferredColorScheme(.dark)
    }
}
