//
//  PersonalInfoView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 09/10/24.
//

import SwiftUI

struct PersonalInfoView: View {
    
    @State private var newFullName: String = ""
    @State private var newEmail: String = ""
    @State private var newUserName: String = ""
    @State private var showingTray = false
    
    @EnvironmentObject var userRepository: UserRepository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Nome:")
                Text(userRepository.user?.fullName ?? "Não definido")
                Spacer()
                Button("Editar") {
                    showingTray.toggle()
                }
            }
            
            HStack {
                Text("Email:")
                Text(userRepository.user?.email ?? "Não definido")
                Spacer()
                Button("Editar") {
                    showingTray.toggle()
                }
            }
            
            HStack {
                Text("Usuário:")
                Text(userRepository.user?.userName ?? "Não definido")
                Spacer()
                Button("Editar") {
                    showingTray.toggle()
                }
            }
            
            Spacer()
            
            if showingTray {
                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("Adicionar mudança")
                            .font(.headline)

                        TextField("Nome do item", text: $newFullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        HStack {
                            Button("Cancelar") {
                                withAnimation {
                                    showingTray.toggle()
                                }
                            }
                            .padding(.horizontal)

                            Button("Salvar") {
                                Task {
                                    if !newFullName.isEmpty {
                                        try await UserManager.shared.updateUserFullName(userId: userRepository.user?.userId ?? "", fullName: newFullName)
                                        let user = try await UserManager.shared.getUser(userId: userRepository.user?.userId ?? "")
                                        userRepository.saveUser(user)
                                        newFullName = ""
                                        showingTray.toggle()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .frame(maxWidth: .infinity)
                    .transition(.move(edge: .bottom))
                    
                    Spacer()
                }
                .padding()
                .animation(.easeInOut, value: showingTray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
