//
//  RatingCard.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI

struct RatingCard: View {
    var rating: Rating
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
            
            VStack(alignment: .leading) {
                Text(rating.source).bold()
                HStack{
                    Spacer()
                    Text("\(rating.value)").foregroundColor(.blue)
                }
            }
            .padding(20)
        }
        .aspectRatio(16/4, contentMode: .fit)
        .shadow(color: Color.black.opacity(0.2), radius: 4, y: 2)
    }
}

struct RatingCard_Previews: PreviewProvider {
    static var previews: some View {
        let rating = Rating(
            source: "Internet Movie Database",
            value: "6.8"
        );
        
        RatingCard(rating: rating)
    }
}
