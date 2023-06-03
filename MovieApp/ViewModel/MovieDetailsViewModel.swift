//
//  MovieDetailsModel.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI
import Combine

class MovieDetailsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var movieDetails: MovieDetails?
    @Published var error: MovieError?
    
    init(imdbID: String) {
        self.isLoading = true
        MovieService.shared.fetchMovieDetails(imdbID: imdbID) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movieDetails = response.movieDetails!
            case .failure(let error):
                self.error = error as MovieError
            }
        }
    }
}
