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
        ZStack(alignment: .bottom) {
      
            Color.blue
                .ignoresSafeArea()
            
            
            VStack {
//                Image(systemName: "heart.fill")
                
//                content
//                    .ignoresSafeArea()
            }
            content
//            RoundedRectangle(cornerRadius: 30)
//                .frame(height: UIScreen.main.bounds.height * 0.5)
//                .foregroundStyle(.white)
//            
            
        }
        .ignoresSafeArea()
    }
    
    private var content: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: UIScreen.main.bounds.height * 0.5)
                .foregroundStyle(.white)
            
            VStack {
                
                TextField("E-mail", text: $emailText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                
                TextField("Password", text: $emailText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                
                Text("Esqueceu a senha?")
                    .padding(.bottom, 10)
                    .frame(alignment: .centerLastTextBaseline)
                
                Button {
    //                saveButtonPressed()
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
                
                
                
                HStack {
    //                Divider()
                    Text("or")
    //                Divider()
                }
                
                alternativeLoginIcons
                
            }
            .frame(maxWidth: .infinity)
            .padding()
//            .background(Color.yellow)
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
