//
//  FirebaseError.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 30/10/24.
//

import Foundation

enum FirebaseError: String {
    case credentialError = "The supplied auth credential is malformed or has expired."
    case passwordError = "The password must be 6 characters long or more."
    case emailAlreadyUsedError = "The email address is already in use by another account."
}
