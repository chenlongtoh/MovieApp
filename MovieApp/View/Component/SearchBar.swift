//
//  SearchBar.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(20)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.blue, lineWidth: self.isEditing ? 1 : 0)
                )
                .onTapGesture {
                    self.isEditing = true
                }
                .animation(.default)
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Cancel")
                }
                .padding(.horizontal, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
