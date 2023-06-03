//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 02/06/2023.
//

import Foundation
import SwiftUI

struct MovieDetailsResponse: Decodable, ApiResponse {
    let status: Bool
    let error: String?
    let movieDetails: MovieDetails?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieDetailsResponseCodingKey.self)
        let statusStr = try container.decode(String.self, forKey: .status)
        status = statusStr == "True"
        error = try container.decodeIfPresent(String.self, forKey: .error)
        movieDetails = try MovieDetails(from: decoder)
    }
    
    func hasValidResponse() -> Bool {
        status && movieDetails != nil
    }
}

enum MovieDetailsResponseCodingKey: String, CodingKey{
    case status = "Response"
    case error = "Error"
}

class MovieDetails: Decodable, Hashable, ObservableObject{
    let title: String
    let genre: String
    let plot: String
    let rawPosterUrl: String
    let ratings: [Rating]
    let imdbRating: Double?
    let imdbVotes: String
    let imdbID: String
    
    @Published var poster: UIImage?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieDetailsCodingKey.self)
        
        title = try container.decode(String.self, forKey: .title)
        genre = try container.decode(String.self, forKey: .genre)
        plot = try container.decode(String.self, forKey: .plot)
        rawPosterUrl = try container.decode(String.self, forKey: .poster)
        ratings = try container.decode([Rating].self, forKey: .ratings)
        imdbVotes = try container.decode(String.self, forKey: .imdbVotes)
        imdbID = try container.decode(String.self, forKey: .imdbID)
        
        let imdbRatingStr = try container.decode(String.self, forKey: .imdbRating)
        imdbRating = Double(imdbRatingStr)
        
        _fetchImage(rawUrl: rawPosterUrl)
    }
    
    required init(imdbID: String, title: String?, genre: String?, imdbRating: Double?, imdbVotes: String?, plot: String?, poster: UIImage?, ratings: [Rating]?) throws {
        self.imdbID = imdbID
        self.title = title ?? "Unknown Title"
        self.genre = genre ?? "Unknown Genre"
        self.imdbRating = imdbRating ?? 0
        self.imdbVotes = imdbVotes ?? "N/A"
        self.plot = plot ?? "N/A"
        self.poster = poster
        self.ratings = ratings ?? []
        self.rawPosterUrl = ""
    }
    
    private func _fetchImage(rawUrl: String) {
        guard let url = URL(string: rawUrl) else { return }
        ImageLoader.shared.loadImage(with: url) { image in
            self.poster = image
        }
        
    }
    
    static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        lhs.imdbID == rhs.imdbID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imdbID)
    }
}

enum MovieDetailsCodingKey: String, CodingKey {
    case title = "Title"
    case year = "Year"
    case rated = "Rated"
    case released = "Released"
    case runtime = "Runtime"
    case genre = "Genre"
    case director = "Director"
    case writer = "Writer"
    case actors = "Actors"
    case plot = "Plot"
    case language = "Language"
    case country = "Country"
    case awards = "Awards"
    case poster = "Poster"
    case ratings = "Ratings"
    case metascore = "Metascore"
    case imdbRating = "imdbRating"
    case imdbVotes = "imdbVotes"
    case imdbID = "imdbID"
    case type = "Type"
    case dVD = "DVD"
    case boxOffice = "BoxOffice"
    case production = "Production"
    case website = "Website"
}

struct Rating: Decodable, Hashable, Encodable {
    let source: String
    let value: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RatingCodingKey.self)
        
        source = try container.decode(String.self, forKey: .source)
        value = try container.decode(String.self, forKey: .value)
    }
    
    init(source: String, value: String) {
        self.source = source
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(source)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RatingCodingKey.self)
        try container.encode(source, forKey: .source)
        try container.encode(value, forKey: .value)
    }
}

enum RatingCodingKey: String, CodingKey {
    case source = "Source"
    case value = "Value"
}
