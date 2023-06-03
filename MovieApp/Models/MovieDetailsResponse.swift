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
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let rawPosterUrl: String
    let ratings: [Rating]
    let metascore: String
    let imdbRating: Double?
    let imdbVotes: String
    let imdbID: String
    let type: String
    let dVD: String
    let boxOffice: String
    let production: String
    let website: String
    
    @Published var poster: UIImage?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieDetailsCodingKey.self)
        
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        rated = try container.decode(String.self, forKey: .rated)
        released = try container.decode(String.self, forKey: .released)
        runtime = try container.decode(String.self, forKey: .runtime)
        genre = try container.decode(String.self, forKey: .genre)
        director = try container.decode(String.self, forKey: .director)
        writer = try container.decode(String.self, forKey: .writer)
        actors = try container.decode(String.self, forKey: .actors)
        plot = try container.decode(String.self, forKey: .plot)
        language = try container.decode(String.self, forKey: .language)
        country = try container.decode(String.self, forKey: .country)
        awards = try container.decode(String.self, forKey: .awards)
        rawPosterUrl = try container.decode(String.self, forKey: .poster)
        ratings = try container.decode([Rating].self, forKey: .ratings)
        metascore = try container.decode(String.self, forKey: .metascore)
        imdbVotes = try container.decode(String.self, forKey: .imdbVotes)
        imdbID = try container.decode(String.self, forKey: .imdbID)
        type = try container.decode(String.self, forKey: .type)
        dVD = try container.decode(String.self, forKey: .dVD)
        boxOffice = try container.decode(String.self, forKey: .boxOffice)
        production = try container.decode(String.self, forKey: .production)
        website = try container.decode(String.self, forKey: .website)
        
        let imdbRatingStr = try container.decode(String.self, forKey: .imdbRating)
        imdbRating = Double(imdbRatingStr)
        
        _fetchImage(rawUrl: rawPosterUrl)
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

struct Rating: Decodable, Hashable {
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
}

enum RatingCodingKey: String, CodingKey {
    case source = "Source"
    case value = "Value"
}
