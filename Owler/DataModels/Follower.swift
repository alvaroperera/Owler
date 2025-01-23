//
//  Follower.swift
//  Owler
//
//  Created by Álvaro Perera on 23/1/25.
//

import FirebaseFirestore

struct Follower: Codable {
    @DocumentID var followerId: String?
    var userID: String
    var userFollowerID: String
}
