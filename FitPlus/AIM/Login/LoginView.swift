//
//  LoginView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 22/02/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var emailText = ""
    @State private var passwordText = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.accentColor
                
                VStack {
                    Spacer()

                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    content
                }
            }
            .ignoresSafeArea()
        }
    }
}

extension LoginView {
    
    private var content: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: UIScreen.main.bounds.height * 0.55)
                .foregroundStyle(.white)
            
            VStack {
                
                TextField("E-mail", text: $emailText)
                    .textInputAutocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                SecureField("Password", text: $passwordText)
                    .modifier(TextFieldModifier())
                
                NavigationLink {
                    TabbarView()
                        .navigationBarBackButtonHidden()
                } label:  {
                        Text("Forgot password?")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.vertical,4)
                }
                
                Button {
                    
                } label: {
                    Text("Login")
                        .modifier(ButtonLabelModifier())
                }
                .padding(.bottom)
                
                Divider()
                
                alternativeLoginIcons
                    .padding(.vertical, 30)
                
                NavigationLink {
                    RegisterView()
                        .navigationBarBackButtonHidden()
                } label:  {
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.black)
                        
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }

    private var alternativeLoginIcons: some View {
        HStack(spacing: 40) {
            Button {
                
            } label: {
                Image("facebookIcon")
            }
            
            Button {
                
            } label: {
                Image("googleIcon")
            }
            
            Button {
                
            } label: {
                Image("appleIcon")
            }
        }
    }
}

#Preview {
    LoginView()
}
