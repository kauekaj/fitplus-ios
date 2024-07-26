//
//  ContentView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabbarView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
