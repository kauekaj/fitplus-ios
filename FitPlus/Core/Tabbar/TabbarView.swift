//
//  TabbarView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 18/07/24.
//

import SwiftUI

struct TabbarView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
//                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
//                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .tag(0)
                .onAppear { selectedTab = 0 }
            
            GrocerShopListView()
                .tabItem {
                    Image(systemName: "cart")
                }
                .tag(1)
                .onAppear { selectedTab = 1 }

            Text("Favorite View")
                .tabItem {
                    Image(systemName: "star")
                }
                .tag(2)
                .onAppear { selectedTab = 2 }
            
            Text("Profile View")
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
                .onAppear { selectedTab = 3 }
        }
        .tint(.accentColor)
    }
}

#Preview {
    TabbarView()
}
