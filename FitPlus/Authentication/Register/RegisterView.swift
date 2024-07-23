//
//  RegisterView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var fullNameText = ""
    @State private var userNameText = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                Color.accentColor
                
                VStack {
                    Spacer()
                    
                    Text("Fit +")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    Spacer()
                    
                    content
                }
                
            }
            .ignoresSafeArea()
        }
    }
    
}

extension RegisterView {
    
    private var content: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: UIScreen.main.bounds.height * 0.55)
                .foregroundStyle(.white)
            
            VStack {
                
                TextField("Enter your e-mail", text: $emailText)
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your password", text: $passwordText)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your full name", text: $fullNameText)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your username", text: $userNameText)
                    .modifier(TextFieldModifier())
                
                Button {
                    
                } label: {
                    Text("Sign Up")
                        .modifier(ButtonLabelModifier())
                }
                
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Alerady have an account?")
                            .foregroundStyle(.black)
                        
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    RegisterView()
}
