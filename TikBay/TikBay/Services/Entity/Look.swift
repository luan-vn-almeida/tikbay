//
//  Video.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import Foundation

struct LooksResponse: Decodable {
    let looks: [Look]
}

struct Look: Decodable {
    let id: Int
    let songURL: String
    let body: String
    let profilePictureURL: String
    let username: String
    let compressedForIosURL: String
}

extension Look: Hashable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case songURL = "song_url"
        case body
        case profilePictureURL = "profile_picture_url"
        case username
        case compressedForIosURL = "compressed_for_ios_url"
    }
}
