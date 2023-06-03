//
//  API_Response.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation

protocol ApiResponse {
    var status: Bool { get }
    var error: String? { get }
    
    func hasValidResponse() -> Bool
}

