//
//  MovieServiceProtocol.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 02/06/2023.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(page: Int, query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetailsResponse, MovieError>) -> ())
    func searchMovie(page: Int, query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidResponse
    case noData
    case serializationError
    case tooManyResult
    case invalidEndpoint
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        case .tooManyResult: return "Too Many Result"
        case .invalidEndpoint: return "Invalid Endpoint"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
