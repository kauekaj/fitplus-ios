//
//  HomeView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 18/07/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            
            Button {
                do {
                    try AuthenticationManager.shared.signOut()
                } catch {
                    print("Failed to sign out")
                }
            } label: {
                Image(systemName: "playstation.logo")
                Text("Sign out")
            }

        }
    }
}

#Preview {
    HomeView()
}
