//
//  ProfileView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 27/07/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
//    @Published private(set) var user: FitPlusUser? = nil
//    
//    func loadCurrentUser() async throws {
//        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
//    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State var presentSheet = false
    
    @EnvironmentObject var userRepository: UserRepository
    
    @State private var rows: [RowData] = [
        RowData(icon: "person", text: "Informação Pessoal", destination: AnyView(PersonalInfoView())),
        RowData(icon: "gear", text: "Ajustes", destination: AnyView(SettingsView())),
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
                        headerInfo()
                        
                        Divider()
                        
                        makeProfileItemsRows()
                                                
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
                
               makeProfileImage()
            }
        }
    }
}

extension ProfileView {
   
    @ViewBuilder
    func makeProfileImage() -> some View {
        Circle()
            .strokeBorder(Color.white, lineWidth: 2)
            .background(Circle()
            .foregroundColor(.gray))
            .frame(width: 150, height: 150)
            .overlay(
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
            )
            .offset(y: -(UIScreen.main.bounds.height * 0.25))

        
        Button(action: {
            presentSheet.toggle()
        }) {
            Image(systemName: "highlighter")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .padding(6)
                .background(Color.yellow)
                .clipShape(Circle())
                .foregroundColor(.black)
                
        }
        .offset(
            x: (UIScreen.main.bounds.width * 0.10),
            y: -(UIScreen.main.bounds.height * 0.18)
        )
        .zIndex(2)
    }
    
    @ViewBuilder
    func headerInfo() -> some View {
        VStack {
            Text(userRepository.user?.fullName ?? "")
                .padding(.top, 64)
                .font(.title)
                .fontWeight(.semibold)
            
            Text(userRepository.user?.userName ?? "")
                .padding(.bottom, 8)
                .font(.footnote)
        }
    }
    
    @ViewBuilder
    func makeProfileItemsRows() -> some View {
        VStack(spacing: 0) {
            ForEach(rows) { rowData in
                NavigationLink(destination: rowData.destination) {
                    RowComponent(icon: true, destination: true, rowData: rowData)
                }
            }
            Spacer()
        }
        .padding(.top, 32)
    }
    
}
