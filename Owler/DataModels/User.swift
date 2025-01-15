//
//  User.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseFirestore

struct User: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var followersNumber: Int
    var followingNumber: Int
    var postsNumber: Int
    var createdAt: String
}
