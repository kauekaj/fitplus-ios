//
//  ProfileView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 27/07/24.
//

import FirebaseAuth
import PhotosUI
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
}


struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State var presentSheet = false
    
    @EnvironmentObject var userRepository: UserRepository
    
    @State private var infoRows: [RowData] = [
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
                        ProfileImagePickerView { selectedImage in
                                print("Imagem selecionada: \(selectedImage)")
                                presentSheet = false
                            }
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
    func makeCameraButton() -> some View {
        Button(action: {
            presentSheet.toggle()
        }) {
            Image(systemName: "camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .padding(6)
                .background(.black.opacity(0.5))
                .clipShape(Circle())
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    func makeProfileImage() -> some View {
        Circle()
            .strokeBorder(Color.white, lineWidth: 2)
            .background(Circle()
                .foregroundColor(.gray))
            .frame(width: 150, height: 150)
            .overlay(
                profileImage()
            )
            .overlay(
                makeCameraButton()
                    .offset(
                        x: (UIScreen.main.bounds.width * 0.10),
                        y: (UIScreen.main.bounds.height * 0.07)
                    )
            )
            .offset(y: -(UIScreen.main.bounds.height * 0.25))
    }
    
    @ViewBuilder
    func profileImage() -> some View {
        if let urlString = userRepository.user?.profileImagePathUrl, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 146, height: 146)
                    .clipShape(Circle())
                
            } placeholder: {
                makeProfileSkelletonView()
            }
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.white)
                .clipShape(Circle())
        }
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
            ForEach(infoRows) { rowData in
                NavigationLink(destination: rowData.destination) {
                    RowComponent(icon: true, destination: true, rowData: rowData)
                }
            }
            Spacer()
        }
        .padding(.top, 32)
    }
    
    @ViewBuilder
    func makeProfileSkelletonView() -> some View {
        VStack {
        ShimmerEffectBox()
            .cornerRadius(25)
            .frame(width: 50, height: 50)
        
        ShimmerEffectBox()
            .cornerRadius(45)
            .frame(width: 90, height: 90)
            .clipShape(TopHalfCircle())

        }
        .padding(.top, 32)
    }
}
