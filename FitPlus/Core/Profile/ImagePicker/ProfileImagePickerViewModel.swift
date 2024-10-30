//
//  ProfileImagePickerViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 30/10/24.
//

import PhotosUI
import SwiftUI

@MainActor
final class ProfileImagePickerViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    func saveProfileImage(user: FitPlusUser, userRepository: UserRepository, item: PhotosPickerItem) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }

        guard let data = try await item.loadTransferable(type: Data.self) else { return false }
        
        if let oldImagePath = user.profileImagePath {
            try await StorageManager.shared.deleteImage(path: oldImagePath)
        }

        let (newImagePath, _) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
        let url = try await StorageManager.shared.getUrlForImage(path: newImagePath)
        try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: newImagePath, url: url.absoluteString)
        
        let updatedUser = try await UserManager.shared.getUser(userId: user.userId)
        userRepository.cacheUser(updatedUser)
        
        return true
    }

    func saveProfileImage(user: FitPlusUser, userRepository: UserRepository, image: UIImage) async throws -> Bool  {
        isLoading = true
        defer { isLoading = false }
        
        if let oldImagePath = user.profileImagePath {
            try await StorageManager.shared.deleteImage(path: oldImagePath)
        }
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            let (path, _) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
            
            let user = try await UserManager.shared.getUser(userId: user.userId)
            userRepository.cacheUser(user)
            
            return true
        }
        
        return false
    }
    
    func getAvatarImages() -> [String] {
        var images: [String] = []
        
        for i in 1...9 {
            let image = "profileAvatar\(i)"
            images.append(image)
        }
        
        return images
    }
}
