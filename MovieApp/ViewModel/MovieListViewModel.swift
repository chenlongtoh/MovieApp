//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI
import Combine

class MovieListViewModel: ObservableObject {
    private var page: Int
    @Published var searchKey: String
    @Published var pagingState: PagingState
    @Published var movieList: [Movie]
    @Published var error: MovieError?
    
    private var preFetchedMovieList: [Movie]
    private var lastDebouncedSearchKey: String
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        page = 1
        searchKey = "Marvel"
        lastDebouncedSearchKey = "Marvel"
        pagingState = .initialLoading
        movieList = []
        preFetchedMovieList = []
        
        $searchKey
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                if(value.count > 0 && self.lastDebouncedSearchKey != value) {
                    self.lastDebouncedSearchKey = value
                    self.page = 1
                    self.pagingState = .initialLoading
                    if NetworkMonitor.shared.isConnected {
                        self.loadMovieFromAPI()
                    } else {
                        self.movieList = self.preFetchedMovieList.filter{
                            $0.title.contains(self.lastDebouncedSearchKey)
                        }
                    }
                }
            } )
            .store(in: &subscriptions)
        
            self.pagingState = .initialLoading
        NetworkMonitor.shared.isConnected ? loadMovieFromAPI() : loadSavedMovies()
    }
    
    func onMovieAppear(_ movie: Movie) {
        guard pagingState == .idle && movieList.last == movie && NetworkMonitor.shared.isConnected else { return }
        pagingState = .paginating
        MovieService.shared.fetchMovies(page: page + 1, query: lastDebouncedSearchKey) { [weak self] (result) in
            guard let self = self else { return }
            self.pagingState = .idle
            switch result {
            case .success(let response):
                self.page += 1
                self.movieList.append(contentsOf: response.movies!)
                self.saveMovies(response.movies!)
            case .failure(let error):
                self.error = error as MovieError
            }
        }
        updateSavedMovieImage()
    }
    
    private func saveMovies(_ movies: [Movie]) {
        let managedContext = CoreDataManager.shared.managedContext
        for movie in movies {
            do {
                let request = MovieCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)
                let numberOfRecords = try managedContext.count(for: request)
                if numberOfRecords == 0 {
                    let movieCoreData = MovieCoreData(context: managedContext)
                    movieCoreData.imdbID = movie.imdbID
                    movieCoreData.poster = movie.poster?.jpegData(compressionQuality: 0.5)
                    movieCoreData.title = movie.title
                    try managedContext.save()
                }
            } catch {
                print("Error saving context \(error)")
            }
        }
        CoreDataManager.shared.saveContext()
    }
    
    private func loadMovieFromAPI() {
        MovieService.shared.fetchMovies(page: page, query: lastDebouncedSearchKey) { [weak self] (result) in
            guard let self = self else { return }
            self.pagingState = .idle
            switch result {
            case .success(let response):
                self.movieList = response.movies!
                self.saveMovies(response.movies!)
            case .failure(let error):
                self.error = error as MovieError
            }
        }
        updateSavedMovieImage()
    }
    
    private func loadSavedMovies() {
        self.pagingState = .idle
        let managedContext = CoreDataManager.shared.managedContext
        do {
            let request = MovieCoreData.fetchRequest()
            let moviesCoreDataList = try managedContext.fetch(request)
            for movieCoreData in moviesCoreDataList {
                if(movieCoreData.imdbID != nil) {
                    let poster = movieCoreData.poster != nil ? UIImage(data: movieCoreData.poster!) : nil
                    let movie = Movie(imdbID: movieCoreData.imdbID!, title: movieCoreData.title, poster: poster)
                    movieList.append(movie)
                }
            }
            preFetchedMovieList = movieList
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func updateSavedMovieImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            let managedContext = CoreDataManager.shared.managedContext
            for movie in self.movieList {
                do {
                    let request = MovieCoreData.fetchRequest()
                    request.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)
                    let movieCoreData = try managedContext.fetch(request).first
                    if (movieCoreData != nil && movie.poster != nil){
                        movieCoreData!.poster = movie.poster?.jpegData(compressionQuality: 0.5)
                        try managedContext.save()
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
            CoreDataManager.shared.saveContext()
        }
    }
}

enum PagingState {
    case initialLoading
    case paginating
    case idle
}
