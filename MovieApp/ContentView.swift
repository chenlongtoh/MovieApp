//
//  ContentView.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 31/05/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authModel = AuthModel()
    var body: some View {
        Group {
            if(authModel.authenticationState == .succeed) {
                MovieListView()
            } else {
                LandingView()
            }
        }
        .environmentObject(authModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
