//
//  MovieDetailsModel.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI
import Combine
import CoreData


class MovieDetailsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var movieDetails: MovieDetails?
    @Published var error: MovieError?
    private let imdbID: String
    
    init(imdbID: String) {
        self.imdbID = imdbID
        self.isLoading = true
        NetworkMonitor.shared.isConnected ? loadFromAPI() : loadSavedDetails()
    }
    
    private func loadFromAPI() {
        MovieService.shared.fetchMovieDetails(imdbID: imdbID) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movieDetails = response.movieDetails!
                
                let managedContext = CoreDataManager.shared.managedContext
                do {
                    let request = MovieCoreData.fetchRequest()
                    request.predicate = NSPredicate(format: "imdbID == %@", response.movieDetails!.imdbID)
                    let movieCoreData = try managedContext.fetch(request).first
                    if(movieCoreData != nil) {
                        movieCoreData!.imdbRating = response.movieDetails!.imdbRating ?? 0
                        movieCoreData!.imdbVotes = response.movieDetails!.imdbVotes
                        movieCoreData!.plot = response.movieDetails!.plot
                        movieCoreData!.genre = response.movieDetails!.genre
                        
                        let encoded = try JSONEncoder().encode(response.movieDetails!.ratings)
                        movieCoreData!.ratings = String(data: encoded, encoding: String.Encoding.utf8)
                        
                        try managedContext.save()
                    }
                } catch {
                    print("Error saving context \(error)")
                }
                CoreDataManager.shared.saveContext()
            case .failure(let error):
                self.error = error as MovieError
            }
        }
    }
    
    private func loadSavedDetails() {
        self.isLoading = false
        do {
            let managedContext = CoreDataManager.shared.managedContext
            let request = MovieCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "imdbID == %@", self.imdbID)
            let movieCoreData = try managedContext.fetch(request).first
            
            if(movieCoreData != nil) {
                var _ratings: [Rating]?
                if movieCoreData!.ratings != nil {
                    let jsonData = movieCoreData!.ratings!.data(using: .utf8)
                    if jsonData != nil {
                        do {
                            _ratings =  try JSONDecoder().decode([Rating].self, from: jsonData!)
                        } catch {
                            print ("Decode Err \(error)")
                        }
                    }
                }
                
                let movieDetails = try MovieDetails(
                    imdbID: self.imdbID,
                    title: movieCoreData!.title,
                    genre: movieCoreData!.genre,
                    imdbRating: movieCoreData!.imdbRating,
                    imdbVotes: movieCoreData!.imdbVotes,
                    plot: movieCoreData!.plot,
                    poster: movieCoreData!.poster != nil ? UIImage(data: movieCoreData!.poster!) : nil ,
                    ratings: movieCoreData!.ratings != nil ? try? JSONDecoder().decode([Rating].self, from: Data(movieCoreData!.ratings!.utf8)) : nil
                )
                self.movieDetails = movieDetails
                try managedContext.save()
            }
        } catch {
            print("Error saving context \(error)")
            self.error = MovieError.noData
        }
    }
}
