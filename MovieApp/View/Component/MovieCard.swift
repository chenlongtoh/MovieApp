//
//  MovieList.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 02/06/2023.
//


import SwiftUI

struct MovieCard: View {
    var poster: UIImage?
    var title: String
    var imdbID: String
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.black)
                
                if poster != nil {
                    Image(uiImage: poster!)
                        .resizable()
                }
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: .init(colors: [Color.black, Color.black.opacity(0)]),
                            startPoint: .init(x: 0, y: 1),
                            endPoint: .init(x: 0, y: 0)
                        )
                    )
                    .scaledToFit()
                
                Text(title)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .font(.system(size:16))
                    .lineLimit(2)
            }
            .cornerRadius(15)
            .shadow(radius: 4)
            .aspectRatio(CGSize(width:595, height:842), contentMode: .fit)
        }
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(
            imdbID: "tt0033317",
            title: "Adventures of Captain Marvel",
            rawPosterUrl: "https://m.media-amazon.com/images/M/MV5BNjg0NTk3NjUyNF5BMl5BanBnXkFtZTgwNDQ5MjM1MjE@._V1_SX300.jpg"
        );
        
        MovieCard(poster: movie.poster, title: movie.title, imdbID: movie.imdbID)
    }
}
