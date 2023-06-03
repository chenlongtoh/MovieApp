//
//  SignInView.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)
struct SignInView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var loginForm: some View{
        VStack(spacing: 15) {
            EmailTextField(email: $authModel.email)
            PasswordSecureField(password: $authModel.password)
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome back 👋")
                .bold()
                .foregroundColor(.blue)
                .font(.system(size: 30))
                .padding(.top, 45)
            Text("I am so happy to see you again. You can continue to login for more features")
                .foregroundColor(.gray)
                .padding(.top, 5)
            loginForm.padding(.top, 50).padding(.horizontal, 10)
            Spacer()
            VStack {
                CustomButton(title: "Login", negative: false) {
                    authModel.login()
                }
                HStack {
                    Text("Don't have an account?")
                    Text("Sign Up").foregroundColor(.blue)
                }
            }
        }.padding(10)
            .alert(isPresented: Binding<Bool>(
                get: { self.authModel.authenticationState == .failed },
                set: { _ in self.authModel.authenticationState = .non }
            )) {
                Alert(title: Text("Login Failed, please try again"),
                      message: nil,
                      dismissButton: .default(Text("OK")))
            }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

struct EmailTextField: View {
    
    @Binding var email: String
    
    var body: some View {
        TextField("Email", text: $email)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
    }
}

struct PasswordSecureField: View {
    
    @Binding var password: String
    
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
    }
}
