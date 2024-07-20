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
                    .textInputAutocapitalization(.never)
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
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.vertical)
                }
                
                Divider()
                
                alternativeLoginIcons
                    .padding(.vertical)
                
                NavigationLink {
                    TabbarView()
                        .navigationBarBackButtonHidden()
                } label:  {
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.black)
                        
                        Text("Register")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
//                    .padding(.vertical, 20)
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
