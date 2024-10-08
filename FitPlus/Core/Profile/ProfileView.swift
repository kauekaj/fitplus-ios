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

struct RoundedCorner: Shape {
    var cornerRadius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State var presentSheet = false
    
    @State private var rows: [RowData] = [
        RowData(icon: "person", text: "Minha Conta", destination: AnyView(Text("Tela Minha Conta"))),
        RowData(icon: "gear", text: "Ajustes", destination: AnyView(Text("Tela Ajustes"))),
        RowData(icon: "bell", text: "Notificações", destination: AnyView(Text("Tela Notificações"))),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.accentColor
                
                VStack(spacing: 0) {
                    Color.accentColor
                        .frame(height: UIScreen.main.bounds.height * 0.25)
                    
                    VStack(spacing: 0) {
                        
                        Text(viewModel.user?.fullName ?? "")
                            .padding(.top, 64)
                            .font(.title)
                        
                        Text(viewModel.user?.userName ?? "")
                            .padding(.bottom, 8)
                            .font(.footnote)

                        Divider()
                        
                        VStack(spacing: 0) {
                            ForEach(rows) { rowData in
                                NavigationLink(destination: rowData.destination) {
                                    RowComponent(rowData: rowData)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 32)
                        
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
                                    .frame(width: 120, height: 44)
//                                    .background(Color.accentColor)
//                                        LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.purple]), startPoint: .leading, endPoint: .trailing)
//                                    )
                                    .cornerRadius(22)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.bottom, 16)

                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                    .zIndex(1)
                    .padding(8)
                    .background(.white)
                    .clipShape(RoundedCorner(cornerRadius: 32, corners: [.topLeft, .topRight]))
                    .sheet(isPresented: $presentSheet) {
                        Text("kauekaj")
                    }
                }
                .edgesIgnoringSafeArea(.top)
                
                
                Circle()
                    .strokeBorder(Color.white, lineWidth: 2)
                    .background(Circle().foregroundColor(.gray))
                    .frame(width: 150, height: 150)
                    .offset(y: -(UIScreen.main.bounds.height * 0.25))
                    .onTapGesture {
                        presentSheet.toggle()
                    }
                
                Button(action: {
                    presentSheet.toggle()
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .padding(4)
                        .background(.gray)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .offset(
                            x: (UIScreen.main.bounds.width * 0.10),
                            y: -(UIScreen.main.bounds.height * 0.18)
                        )
                        .zIndex(2)
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}


struct RowData: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let destination: AnyView
}

struct RowComponent: View {
    var rowData: RowData
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: rowData.icon)
                .foregroundColor(.black)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            
            Text(rowData.text)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
 
        .onTapGesture {
            //
        }
    }
}
