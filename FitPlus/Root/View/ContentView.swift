//
//  ContentView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @State private var showIntermediateLoading = false
    
    var body: some View {
        Group {
            if viewModel.isLoading || showIntermediateLoading {
                ProgressView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: showIntermediateLoading)
            } else {
                if viewModel.userSession != nil {
                    TabbarView()
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5), value: viewModel.userSession)
                } else {
                    LoginView()
                        .transition(.move(edge: .leading))
                        .animation(.easeInOut(duration: 0.5), value: viewModel.userSession)
                }
            }
        }
        .onChange(of: viewModel.userSession) { newSession in
            showIntermediateLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showIntermediateLoading = false
            }
        }
    }
}
