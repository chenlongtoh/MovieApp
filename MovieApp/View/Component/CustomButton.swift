//
//  Button.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    var title: String
    var negative: Bool
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
        .foregroundColor(negative ? .blue : .white)
        .background(negative ? .white : .blue)
        .cornerRadius(16)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Login", negative: true, action: {})
    }
}
