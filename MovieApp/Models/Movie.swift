//
//  Movie.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 02/06/2023.
//

import Foundation
import UIKit

struct SearchResult: Decodable {
    let movies: [Movie]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchResultCodingKey.self)
        
        movies = try container.decode([Movie].self, forKey: .search)
    }
}

enum SearchResultCodingKey: String, CodingKey {
    case search = "Search"
}

class Movie: Decodable, Hashable, ObservableObject {
    let imdbID: String
    let title: String
    let year: String
    let type: String
    let rawPosterUrl: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieCodingKey.self)
        
        imdbID = try container.decode(String.self, forKey: .imdbID)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        type = try container.decode(String.self, forKey: .type)
        rawPosterUrl = try container.decode(String.self, forKey: .rawPosterUrl)
    }
    
    required init(imdbID: String, title: String, year: String, type: String, rawPosterUrl: String) {
        self.imdbID = imdbID
        self.title = title
        self.year = year
        self.type = type
        self.rawPosterUrl = rawPosterUrl
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
