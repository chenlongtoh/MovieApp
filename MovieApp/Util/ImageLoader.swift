//
//  ImageLoader.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import SwiftUI
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader {
    static let shared = ImageLoader()
    private init() {}

    func loadImage(with url: URL, completion: @escaping ((UIImage) -> Void)) {
        let urlString = url.absoluteString
        if let imageFromCache = _imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(imageFromCache)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            _imageCache.setObject(image, forKey: urlString as AnyObject)
            DispatchQueue.main.async{
                completion(image)
            }
        })
        .resume()
    }
}
