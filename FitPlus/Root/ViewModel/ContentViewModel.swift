//
//  ContentViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//


import Combine
import Firebase
import FirebaseAuth
import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var isLoading: Bool = true

    private var cancellabes = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthenticationManager.shared.$userSession.sink { [weak self] userSession in
            Task { @MainActor in
                self?.userSession = userSession
                self?.isLoading = false
            }
        }.store(in: &cancellabes)
    }
    
}
