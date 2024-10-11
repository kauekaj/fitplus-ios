//
//  PersonalInfoView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 09/10/24.
//

import SwiftUI

struct PersonalInfoView: View {

    @State private var field: String = ""
    @State private var inputText: String = ""

    @State private var isEmailRegistered = false
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

                TextField("Nome do item", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if isEmailRegistered == true {
                    Text("Email já registrado")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                HStack {
                    Button("Cancelar") {
                        withAnimation {
                            shouldShowTray.toggle()
                        }
                    }
                    .padding(.horizontal)

                    Button("Salvar") {
                        Task {
                            if field == FitPlusUser.CodingKeys.email.rawValue {
                                do {
                                    try await AuthenticationManager.shared.updateEmail(email: inputText)
                                } catch {
                                    print("Email already registered")
                                    isEmailRegistered.toggle()
                                }
                            } else {
                                if !inputText.isEmpty {
                                    try await UserManager.shared.updateUserData(
                                        userId: userRepository.user?.userId ?? "",
                                        field: field,
                                        value: inputText
                                    )

                                    let user = try await UserManager.shared.getUser(userId: userRepository.user?.userId ?? "")
                                    userRepository.saveUser(user)
                                    shouldShowTray.toggle()
                                    isEmailRegistered.toggle()
                                    field = ""
                                    inputText = ""
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
