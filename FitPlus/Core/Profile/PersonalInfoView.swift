//
//  PersonalInfoView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 09/10/24.
//

import SwiftUI

enum trayError: String {
    case idle = ""
    case isEmailRegistered = "Email já registrado"
    case emptyField = "O campo está vazio"
}

struct PersonalInfoView: View {
    
    @State private var field: String = ""
    @State private var inputText: String = ""
    @State private var showTrayError: trayError = .idle
    @State private var shouldShowTray = false
    
    @EnvironmentObject var userRepository: UserRepository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Informações Pessoais")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            
            HStack {
                Text("Nome:")
                Text(userRepository.user?.fullName ?? "")
                Spacer()
                Button("Editar") {
                    shouldShowTray.toggle()
                    field = FitPlusUser.CodingKeys.fullName.rawValue
                }
            }
            
            HStack {
                Text("Email:")
                Text(userRepository.user?.email ?? "")
                Spacer()
                Button("Editar") {
                    shouldShowTray.toggle()
                    field = FitPlusUser.CodingKeys.email.rawValue
                }
            }
            
            HStack {
                Text("Usuário:")
                Text(userRepository.user?.userName ?? "")
                Spacer()
                Button("Editar") {
                    shouldShowTray.toggle()
                    field = FitPlusUser.CodingKeys.userName.rawValue
                }
            }
            
            HStack {
                Text("Senha:")
                Text("******")
                Spacer()
                Button("Editar") {
                    shouldShowTray.toggle()
                    field = "password"
                }
            }
            
            Spacer()
            
            if shouldShowTray {
                makeTray()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension PersonalInfoView {
    
    func makeTray() -> some View {
        VStack {
            VStack(spacing: 16) {
                Text("Adicionar mudança")
                    .font(.headline)
                
                if field == "password" {
                    SecureField("Digite aqui...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                } else {
                    TextField("Digite aqui...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                if showTrayError != .idle {
                    Text(showTrayError.rawValue)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
                
                HStack {
                    Button("Cancelar") {
                        withAnimation {
                            shouldShowTray.toggle()
                            showTrayError = .idle
                            field = ""
                            inputText = ""
                        }
                    }
                    .padding(.horizontal)
                    
                    Button("Salvar") {
                        Task {
                            if field == "password" && !inputText.isEmpty {
                                do {
                                    try await AuthenticationManager.shared.updatePassword(password: inputText)
                                    shouldShowTray.toggle()
                                } catch {
                                    print("Error updating password")
                                }
                            } else if field == FitPlusUser.CodingKeys.email.rawValue && !inputText.isEmpty {
                                do {
                                    try await AuthenticationManager.shared.updateEmail(email: inputText)
                                    shouldShowTray.toggle()
                                    field = ""
                                    inputText = ""
                                } catch {
                                    print("Email already registered")
                                    showTrayError = .isEmailRegistered
                                }
                            } else {
                                if !inputText.isEmpty {
                                    do {
                                        try await UserManager.shared.updateUserData(
                                            userId: userRepository.user?.userId ?? "",
                                            field: field,
                                            value: inputText
                                        )
                                        
                                        let user = try await UserManager.shared.getUser(userId: userRepository.user?.userId ?? "")
                                        userRepository.saveUser(user)
                                        shouldShowTray.toggle()
                                        showTrayError = .idle
                                        field = ""
                                        inputText = ""
                                        
                                    } catch  {
                                        print("Error updating data.")
                                    }
                                } else {
                                    showTrayError = .emptyField
                                }
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
            .transition(.move(edge: .top))
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: shouldShowTray)
    }
}
