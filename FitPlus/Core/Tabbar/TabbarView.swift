//
//  TabbarView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 18/07/24.
//

import SwiftUI

struct TabbarView: View {
    
    @State private var selectedTab = 0
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white

        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
                .onAppear { selectedTab = 0 }
            
            ListsView()
                .tabItem {
                    Image(systemName: "cart")
                }
                .tag(1)
                .onAppear { selectedTab = 1 }

            RecipeListView()
                .tabItem {
                    Image(systemName: "book.fill")
                }
                .tag(2)
                .onAppear { selectedTab = 2 }
            
            ProfileView()
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
