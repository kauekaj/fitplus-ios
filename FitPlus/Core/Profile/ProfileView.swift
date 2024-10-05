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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.accentColor

                VStack(spacing: 0) {
                    Color.accentColor
                        .frame(height: UIScreen.main.bounds.height * 0.25)
                    
                    VStack {
                        
                        Text(viewModel.user?.userName ?? "")
                            .font(.title)
                            .padding(.top, 64)
                        
                        VStack(alignment: .leading) {
                        Text("Label 1")
                            .font(.headline)
                            .padding(.top, 32)
                        
                        Text("Nome: \(viewModel.user?.fullName ?? "")")
                            .font(.headline)
                        
                        Text("email: \(viewModel.user?.email ?? "")")
                            .font(.headline)

                        Text("ID: \(viewModel.user?.userId ?? "")")
                            .font(.headline)
                        }
                        
                        VStack {
                            Spacer()

                            Button {
                                do {
                                    try AuthenticationManager.shared.signOut()
                                } catch {
                                    print("Failed to sign out")
                                }
                            } label: {
                                Image(systemName: "playstation.logo")
                                Text("Sign out")
                            }
                            .background(.gray.opacity(0.5))
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
                        .frame(width: 24, height: 24)
                        .padding(2)
                        .background(.cyan)
                        .foregroundColor(.red)
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
