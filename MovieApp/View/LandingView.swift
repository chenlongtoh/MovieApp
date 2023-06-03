//
//  LandingView.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI

struct LandingView: View {
    @State var pushActive = false
    var centerComponent: some View {
        VStack {
            Text("Access more with an account").bold()
                .foregroundColor(.blue)
                .font(.system(size: 30))
                .multilineTextAlignment(.center)
            Text("Login to an account so you could access more feature")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 2)
            NavigationLink(destination:
               SignInView(),
               isActive: self.$pushActive) {
                 EmptyView()
            }.hidden()
        }
    }
    var body: some View {
        NavigationView {
        VStack {
            Spacer()
            centerComponent
            Spacer()
            VStack {
                CustomButton(title: "Login", negative: false) {
                    self.pushActive = true
                }
                CustomButton(title: "Sign Up", negative: true) {
                    
                }
            }
        }.padding(10)
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
