//
//  TabbarView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 18/07/24.
//

import SwiftUI

struct TabbarView: View {
    
    var body: some View {
        TabView {
            
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("home")
            }
            
            NavigationStack {

            }
            .tabItem {
                Image(systemName: "cart")
                Text("List")
            }
            
            NavigationStack {
//                FavoriteView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            
            NavigationStack {
//                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        
    }
}

#Preview {
    TabbarView()
}
