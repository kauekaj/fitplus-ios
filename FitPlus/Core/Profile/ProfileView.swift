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
    func makeProfileImage() -> some View {
        Circle()
            .strokeBorder(Color.white, lineWidth: 2)
            .background(Circle()
            .foregroundColor(.gray))
            .frame(width: 150, height: 150)
            .overlay(
                profileImage()
            )
            .offset(y: -(UIScreen.main.bounds.height * 0.25))

        
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
        .offset(
            x: (UIScreen.main.bounds.width * 0.10),
            y: -(UIScreen.main.bounds.height * 0.16)
        )
        .zIndex(2)
    }
    
    @ViewBuilder

    func profileImage() -> some View {
        if let urlString = userRepository.user?.profileImagePathUrl, let url = URL(string: urlString) {
            AnyView(AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 146, height: 146)
                    .clipShape(Circle())
 
            } placeholder: {
                ProgressView()
                    .foregroundStyle(.white)
                    .frame(width: 146, height: 146)
            })
        } else {
            AnyView(Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit))
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

@MainActor
final class ProfileImagePickerViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false

    func saveProfileImage(user: FitPlusUser, userRepository: UserRepository, item: PhotosPickerItem) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        guard let data = try await item.loadTransferable(type: Data.self) else { return false }
        let (path, _) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
        let url = try await StorageManager.shared.getUrlForImage(path: path)
        try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
        
        let user = try await UserManager.shared.getUser(userId: user.userId)
        userRepository.cacheUser(user)
        
        return true
    }
    
    func saveProfileImage(user: FitPlusUser, userRepository: UserRepository, image: UIImage) async throws -> Bool  {
        isLoading = true
        defer { isLoading = false }
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            let (path, _) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
            
            let user = try await UserManager.shared.getUser(userId: user.userId)
            DispatchQueue.main.async {
                userRepository.cacheUser(user)
            }
            
            return true
        }
        return false
    }
}

struct ProfileImagePickerView: View {
//    let images = ["profileAvatar1", "photo2", "photo3", "photo4", "photo5", "photo6", "photo7", "photo8", "photo9", "photo10", "photo11", "photo12", "photo13", "photo14", "photo15", "photo16", "photo17", "photo18"]
    @State private var avatarImages = ProfileAvatarManager.shared.getAvatarImages()

    @State private var showSheet = false
    @State private var selectedImage: UIImage? = nil
    var didSelectImage: (String) -> Void
    @State private var selectedLibraryImage: PhotosPickerItem? = nil
    
    @EnvironmentObject var userRepository: UserRepository
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel = ProfileImagePickerViewModel()
    
    var body: some View {
        
        VStack(spacing: 8) {
            if viewModel.isLoading {
                ProgressView("Carregando...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
            } else {
                
                VStack(spacing: 8) {
                    Text("Escolha uma nova foto de perfil")
                        .font(.headline)
                        .padding(.vertical, 16)
                    
                    HStack {
                        Button(action: {
                            showSheet.toggle()
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                    .font(.title)
                                    .padding(.trailing, 8)
                                Text("Tirar uma nova foto")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $showSheet) {
                            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                        }
                        
                        Button(action: {
                            // Intentionally not implemented
                        }) {
                            HStack {
                                PhotosPicker(
                                    selection: $selectedLibraryImage,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle")
                                            .font(.title)
                                            .padding(.trailing, 8)
                                        Text("Selecionar uma foto")
                                    }
                                }
                            }
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                            ForEach(avatarImages, id: \.self) { image in
                                Button(action: {
                                    if let user = userRepository.user,
                                       let image = UIImage.fromAsset(named: image) {
                                        Task {
                                            do {
                                                let success = try await viewModel.saveProfileImage(user: user, userRepository: userRepository, image: (image))
                                                if success {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        presentationMode.wrappedValue.dismiss()
                                                    }
                                                }
                                            } catch {
                                                print("Erro ao salvar imagem: \(error)")
                                            }
                                        }
                                    }
                                }) {
                                    Image(image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                }
                            }
                        }
                        .padding()
                        
                    }
                    .scrollIndicators(.hidden)
                }
                .onChange(of: selectedLibraryImage) { newValue in
                    if let newValue, let user = userRepository.user {
                        Task {
                            do {
                                let success = try await viewModel.saveProfileImage(user: user, userRepository: userRepository, item: newValue)
                                if success {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            } catch {
                                print("Erro ao salvar imagem: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    
}


import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


class ProfileAvatarManager {
    static let shared = ProfileAvatarManager()
    
    private init() {}
    
    func getAvatarImages() -> [String] {
        var images: [String] = []
        
        for i in 1...9 {
            var image = "profileAvatar\(i)"
            images.append(image)
        }
        
        return images
    }
}
