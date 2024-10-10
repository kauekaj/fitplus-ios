//
//  Bundle+Extensions.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 09/10/24.
//

import Foundation

extension Bundle {
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var appBuild: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}
