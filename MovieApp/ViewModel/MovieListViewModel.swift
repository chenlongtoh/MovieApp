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
    
    private var lastDebouncedSearchKey: String
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        page = 1
        searchKey = "Marvel"
        lastDebouncedSearchKey = "Marvel"
        pagingState = .initialLoading
        movieList = []
        
        $searchKey
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                if(value.count > 0 && self.lastDebouncedSearchKey != value) {
                    self.lastDebouncedSearchKey = value
                    self.page = 1
                    self.loadMovies()
                }
            } )
            .store(in: &subscriptions)
        loadMovies()
    }
    
    private func loadMovies(){
        self.pagingState = .initialLoading
        MovieService.shared.fetchMovies(page: page, query: lastDebouncedSearchKey) { [weak self] (result) in
            guard let self = self else { return }
            self.pagingState = .idle
            switch result {
            case .success(let response):
                self.movieList = response.movies!
            case .failure(let error):
                self.error = error as MovieError
            }
        }
    }
    
    func onMovieAppear(_ movie: Movie) {
        guard pagingState == .idle && movieList.last == movie else { return }
        pagingState = .paginating
        MovieService.shared.fetchMovies(page: page + 1, query: lastDebouncedSearchKey) { [weak self] (result) in
            guard let self = self else { return }
            self.pagingState = .idle
            switch result {
            case .success(let response):
                self.page += 1
                self.movieList.append(contentsOf: response.movies!)
            case .failure(let error):
                self.error = error as MovieError
            }
        }
    }
}

enum PagingState {
    case initialLoading
    case paginating
    case idle
}
