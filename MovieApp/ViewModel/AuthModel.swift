//
//  AuthModel.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation

private let userEmail = "VVVBB"
private let userPassword = "@bcd1234"

enum AuthenticationState {
    case non
    case failed
    case succeed
}

class AuthModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authenticationState: AuthenticationState = .non
    
    func login() {
        if(email == userEmail && password == userPassword) {
            authenticationState = .succeed
        } else {
            authenticationState = .failed
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
