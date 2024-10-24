//
//  PersonalInfoView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 09/10/24.
//

import SwiftUI

enum TrayError: String {
    case idle = ""
    case invalidEmail = "Email não é válido"
    case isEmailRegistered = "Email já registrado"
    case emptyField = "O campo está vazio"
    case passwordDoesNotMatch = "As senhas estão diferentes."
    case fillOutEveryField = "Gentileza preencher todos os campos."

}

struct PersonalInfoView: View {
    
    @State private var field: String = ""
    @State private var inputText: String = ""
    @State private var showTrayError: TrayError = .idle
    @State private var shouldShowTray = false
    
    @EnvironmentObject var userRepository: UserRepository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Informações Pessoais")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 8)

            makeUserDataRow(
                label: "Nome:",
                value: userRepository.user?.fullName ?? "",
                field: FitPlusUser.CodingKeys.fullName.rawValue
            )
            
            makeUserDataRow(
                label: "Email:",
                value: userRepository.user?.email ?? "",
                field: FitPlusUser.CodingKeys.email.rawValue
            )

            makeUserDataRow(
                label: "Usuário:",
                value: userRepository.user?.userName ?? "",
                field: FitPlusUser.CodingKeys.userName.rawValue
            )
            
            if shouldShowTray {
                makeTray()
            }
            
            Spacer()
            
            makeLogoutButton()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension PersonalInfoView {
    
    @ViewBuilder
    func makeUserDataRow(label: String, value: String, field: String) -> some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
            Text(value)
            Spacer()
            Button("Editar") {
                shouldShowTray.toggle()
                self.field = field
            }
            .fontWeight(.bold)
        }
        .padding()
        .background(.clear)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray, lineWidth: 0.3)
        )
    }
    
    @ViewBuilder
    func makeLogoutButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                do {
                    try AuthenticationManager.shared.signOut()
                } catch {
                    print("Failed to sign out")
                }
            } label: {
                Text("Sair")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 48)
                    .background(Color.accentColor)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            }
            .padding(.bottom, 16)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    func makeTray() -> some View {
        VStack {
            VStack(spacing: 16) {
                Text("Adicionar mudança")
                    .font(.headline)
                
                TextField("Digite aqui...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
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
                                    let user = try await UserManager.shared.getUser(userId: userRepository.user?.userId ?? "")
                                    userRepository.cacheUser(user)
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
                                        DispatchQueue.main.async {
                                            userRepository.cacheUser(user)
                                        }
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
            .shadow(radius: 8)
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .top))
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: shouldShowTray)
    }
}
