//
//  ListView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationLink {
            GrocerShopListView()
//                .navigationBarBackButtonHidden()
        } label:  {
                Text("Ir para lista de compras")
                    .foregroundStyle(.black)
        }
    }
}

#Preview {
    ListView()
}
