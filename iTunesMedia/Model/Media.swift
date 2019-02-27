//
//  Media.swift
//  iTunesMedia
//
//  Created by Naomi Schettini on 2/22/19.
//  Copyright © 2019 Naomi Schettini. All rights reserved.
//

import Foundation

struct MediaObject: Codable {
    var feed: Feed
}

struct Feed: Codable {
    var results: [Result]
}

struct Result: Codable {
    var artistName: String
    var name: String
    var artworkUrl100: String
    var kind: String
}

