//
//  MovieService.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 02/06/2023.
//

import Foundation

class MovieService: MovieServiceProtocol {
    static let shared = MovieService()
    private init() {}
    
    private let apiKey = "6fc87060"
    private let baseAPIURL = "http://www.omdbapi.com/"
    private let urlSession = URLSession.shared
    
    func fetchMovies(page: Int, query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: baseAPIURL) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "s": query,
            "page": "\(page)",
            "type": "Movie",
        ], completion: completion)
    }
    
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetailsResponse, MovieError>) -> ()) {
        guard let url = URL(string: baseAPIURL) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadURLAndDecode(url: url, params: [
            "i": imdbID
        ], completion: completion)
    }
    
    func searchMovie(page: Int, query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: baseAPIURL) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "s": query,
            "page": "\(page)",
            "type": "Movie",
        ], completion: completion)
    }
    
    private func loadURLAndDecode<D>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) where D:Decodable, D:ApiResponse {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
        ]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(D.self, from: data)
                if(decodedResponse.hasValidResponse()) {
                    self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
                } else {
                    guard let error = decodedResponse.error, !decodedResponse.status else {
                        self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                        return
                    }
                    if (error == "Too many results.") {
                        self.executeCompletionHandlerInMainThread(with: .failure(.tooManyResult), completion: completion)
                    }else {
                        self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                    }
                }
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) where D:Decodable, D:ApiResponse {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
