//
//  DeleteUserProfileView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 19/10/24.
//

import SwiftUI

struct DeleteAccountView: View {
    
    @State private var showAlert = false
    @State private var shouldShowSuccessfulTray = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userRepository: UserRepository

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "person.crop.circle.fill.badge.xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(Color.red, Color.black)
                
                Text("Clique no botão abaixo para proceder com a exclusão definitiva da sua conta.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                Button(action: {
                    showAlert = true
                }) {
                    Text("Deletar")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Excluir Conta"),
                        message: Text("Você realmente deseja excluir sua conta? Esta ação não pode ser desfeita."),
                        primaryButton: .destructive(Text("Excluir")) {
                            Task {
                                try await deleteUserAccount(userId: userRepository.user?.userId ?? "")
                            }
                        },
                        secondaryButton: .cancel(Text("Cancelar"))
                    )
                }
                
                Spacer()
            }
            
            if shouldShowSuccessfulTray {
                makeTray()
            }
        }
    }
    
    func makeTray() -> some View {
        VStack {
            VStack(spacing: 0) {
                
                HStack {
                        Text("Conta excluída com sucesso!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                            .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            shouldShowSuccessfulTray.toggle()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(8)
                    }
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                }

            }
            .padding()
            .background(Color(red: 0.8, green: 1.0, blue: 0.8))
            .cornerRadius(16)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .top))
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: shouldShowSuccessfulTray)
    }
    
    func deleteUserAccount(userId: String) async throws {
        do {
            try await AuthenticationManager.shared.deleteUser()
            
            try await UserManager.shared.deleteUserFirestoreData(userId: userId)
            
            shouldShowSuccessfulTray.toggle()
        } catch {
            throw NSError(domain: "UserManagerError", code: 500, userInfo: [NSLocalizedDescriptionKey : "Erro ao deletar a conta: \(error.localizedDescription)"])
        }
    }
}
