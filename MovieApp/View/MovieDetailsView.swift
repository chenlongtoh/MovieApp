//
//  MovieDetailsView.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    init(_ imdbID: String) {
        viewModel = MovieDetailsViewModel(imdbID: imdbID)
    }
    
    var poster: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.black)
                
                if (viewModel.movieDetails?.poster != nil) {
                    Image(uiImage: viewModel.movieDetails!.poster!)
                        .resizable()
                }
            }
            .cornerRadius(15)
            .shadow(radius: 4)
            .aspectRatio(CGSize(width:595, height:842), contentMode: .fit)
        }
    }
    
    var body: some View {
        if(viewModel.isLoading) {
            ProgressView()
                .scaleEffect(3, anchor: .center)
                .tint(.blue)
        } else if (viewModel.movieDetails == nil || viewModel.error != nil){
            Text("Error, movie not found")
        } else {
            let movieDetails = viewModel.movieDetails!
            ZStack{
                ScrollView {
                    VStack{
                        VStack(alignment: .leading)  {
                            poster.frame(height: 200).padding(10)
                            HStack{
                                if(movieDetails.imdbRating != nil) {
                                    FiveStarView(rating: Decimal(movieDetails.imdbRating!), color: .blue, backgroundColor: .blue.opacity(0.5))
                                        .frame(height: 5)
                                    Text(String(format: "%.1f / 10", movieDetails.imdbRating!))
                                        .foregroundColor(.blue)
                                        .font(.system(size: 25))
                                        .fontWeight(.bold)
                                }
                                Text("\(movieDetails.imdbVotes) Ratings").foregroundColor(.gray)
                            }
                            Text(movieDetails.title).font(.system(size: 20)).bold().padding(.bottom, 5)
                            Text(movieDetails.genre).foregroundColor(.gray)
                            Text("Plot Summary").padding(.top, 25).bold().padding(.bottom, 5)
                            Text(movieDetails.plot).foregroundColor(.gray)
                            Text("Other Ratings").padding(.top, 25).padding(.bottom, 5)
                        }.padding(.horizontal, 20)
                        ScrollView(.horizontal) {
                            HStack{
                                ForEach(movieDetails.ratings, id: \.self){rating in
                                    RatingCard(rating: rating)
                                }
                            }
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                        }
                    }
                }
            }
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView("tt0033317")
    }
}
