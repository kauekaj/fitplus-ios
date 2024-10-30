//
//  ProfileImagePickerView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 30/10/24.
//

import PhotosUI
import SwiftUI

struct ProfileImagePickerView: View {
    
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
                        .padding(.top, 16)
                    
                    HStack {
                        Button(action: {
                            showSheet.toggle()
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(8)
                                Text("Tirar uma nova foto")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.accentColor)
                            .cornerRadius(24)
                        }
                        .sheet(isPresented: $showSheet) {
                            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                        }
                        
                        PhotosPicker(
                            selection: $selectedLibraryImage,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(8)
                                Text("Selecionar uma foto")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.accentColor)
                            .cornerRadius(24)
                        }
                    }
                    .padding()
                    
                    Divider()
                        .padding()
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                            ForEach(viewModel.getAvatarImages(), id: \.self) { image in
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
                .onChange(of: selectedImage) { newValue in
                    if let newValue, let user = userRepository.user {
                        Task {
                            do {
                                let success = try await viewModel.saveProfileImage(user: user, userRepository: userRepository, image: newValue)
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
