//
//  SearchBarView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-03.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.theme.secondary)
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(searchText.isEmpty ? .theme.secondary : .theme.accent)
                .disableAutocorrection(true)
            Button {
                searchText = ""
                UIApplication.shared.endEditing()
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .foregroundColor(.theme.accent)
            .opacity(searchText.isEmpty ? 0 : 1)
        }
        .font(.headline)
        .padding()
        .background(Color.theme.background)
        .cornerRadius(25.0)
        .shadow(color: .theme.accent.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
        .padding(.vertical)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant("Hello"))
            .previewLayout(.sizeThatFits)
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
