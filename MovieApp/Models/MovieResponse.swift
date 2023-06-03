//
//  Movie.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 02/06/2023.
//

import Foundation
import UIKit

struct MovieResponse: Decodable, ApiResponse {
    
    let status: Bool
    let error: String?
    let movies: [Movie]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchResultCodingKey.self)
        
        let statusStr = try container.decode(String.self, forKey: .status)
        status = statusStr == "True"
        
        movies = try container.decodeIfPresent([Movie].self, forKey: .search)
        error = try container.decodeIfPresent(String.self, forKey: .error)
    }
    
    func hasValidResponse() -> Bool {
        status && movies != nil
    }
}

enum SearchResultCodingKey: String, CodingKey {
    case status = "Response"
    case search = "Search"
    case error = "Error"
}

class Movie: Decodable, Hashable, ObservableObject {
    let imdbID: String
    let title: String
    let rawPosterUrl: String
    
    @Published var poster: UIImage?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieCodingKey.self)
        
        imdbID = try container.decode(String.self, forKey: .imdbID)
        title = try container.decode(String.self, forKey: .title)
        rawPosterUrl = try container.decode(String.self, forKey: .rawPosterUrl)
        
        _fetchImage(rawUrl: rawPosterUrl)
    }
    
    required init(imdbID: String, title: String, rawPosterUrl: String) {
        self.imdbID = imdbID
        self.title = title
        self.rawPosterUrl = rawPosterUrl
        
        _fetchImage(rawUrl: rawPosterUrl)
    }
    
    required init(imdbID: String, title: String?, poster: UIImage?) {
        self.imdbID = imdbID
        self.title = title ?? "Unknow title"
        self.poster = poster
        self.rawPosterUrl = ""
    }

    private func _fetchImage(rawUrl: String) {
        guard let url = URL(string: rawUrl) else { return }
        ImageLoader.shared.loadImage(with: url) { image in
            self.poster = image
        }
        
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.imdbID == rhs.imdbID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imdbID)
    }
}

enum MovieCodingKey: String, CodingKey {
    case imdbID = "imdbID"
    case title = "Title"
    case year = "Year"
    case type = "Type"
    case rawPosterUrl = "Poster"
}
