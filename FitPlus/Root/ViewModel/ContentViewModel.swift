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
    
    private var cancellabes = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    @MainActor
    private func setupSubscribers() {
        AuthenticationManager.shared.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }.store(in: &cancellabes)
    }
    
}
