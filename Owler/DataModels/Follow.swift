//
//  Following.swift
//  Owler
//
//  Created by Álvaro Perera on 23/1/25.
//

import FirebaseFirestore

struct Follow: Codable {
    @DocumentID var followId: String?
    var userID: String
    var userFollowedID: String
}
