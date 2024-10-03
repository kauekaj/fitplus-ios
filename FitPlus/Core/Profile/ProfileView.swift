//
//  ProfileView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 27/07/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: FitPlusUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {

            VStack {
                Text("Nome: \(viewModel.user?.fullName ?? "")")
                Text("email: \(viewModel.user?.email ?? "")")
                Text("ID: \(viewModel.user?.userId ?? "")")
                
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
                .padding()
            }
            .task {
                try? await viewModel.loadCurrentUser()
//                print("kauekaj: \(String(describing: viewModel.user))")
            }
        }
    }
}
