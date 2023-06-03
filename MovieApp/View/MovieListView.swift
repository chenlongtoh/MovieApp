//
//  MovieListView.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//
//

import SwiftUI

private let gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 20, alignment: .center), count: 2)

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    
    init() {
        viewModel = MovieListViewModel()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 15) {
                    SearchBar(text: $viewModel.searchKey)
                        .padding(.horizontal, 20)
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 20) {
                            ForEach(viewModel.movieList, id: \.self){movie in
                                
                                NavigationLink(destination: MovieDetailsView(movie.imdbID)){
                                    MovieCard(poster: movie.poster, title: movie.title, imdbID: movie.imdbID)
                                        .onAppear{
                                            self.viewModel.onMovieAppear(movie)
                                        }
                                }
                            }
                        }.padding(.horizontal, 20)
                        if (viewModel.pagingState == .paginating) {
                            ProgressView().padding(10)
                        }
                    }
                }
                .alert(isPresented: Binding<Bool>(
                    get: { self.viewModel.error != nil },
                    set: { _ in self.viewModel.error = nil }
                )) {
                    Alert(title: Text("Error: \(self.viewModel.error?.localizedDescription ?? "Error") "),
                          message: nil,
                          dismissButton: .default(Text("OK")))
                }
                if(viewModel.pagingState == .initialLoading){
                    Group {
                        Color(.systemBackground).opacity(0.6)
                        ProgressView()
                            .scaleEffect(3, anchor: .center)
                            .tint(.blue)
                        
                    }
                }
            }
            
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
