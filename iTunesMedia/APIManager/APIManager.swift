//
//  APIManager.swift
//  iTunesMedia
//
//  Created by Naomi Schettini on 2/22/19.
//  Copyright © 2019 Naomi Schettini. All rights reserved.
//

import Foundation

class APIManager {
    
    enum MediaType {
        case book
        case music
    }
    
    func getAppropriateURLForMediaType(type: MediaType, amount: Int) -> String {
        var url = ""
        switch type {
        case MediaType.book:
            url = "https://rss.itunes.apple.com/api/v1/us/books/top-free/all/\(amount)/explicit.json"
            return url
        case MediaType.music:
            url = "https://rss.itunes.apple.com/api/v1/us/itunes-music/new-music/all/\(amount)/explicit.json"
            return url
        }
    }
    
    typealias CompletionHandler = (_ success: (MediaObject)) -> Void
    
    func getMediaOfType(type: MediaType, amount: Int, completion: @escaping CompletionHandler) {
        let url = URL(string: getAppropriateURLForMediaType(type: type, amount: amount))
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let mediaObject = try decoder.decode(MediaObject.self, from: data)
                completion(mediaObject)
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
}
