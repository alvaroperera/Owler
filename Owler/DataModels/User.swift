//
//  User.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseFirestore

struct User: Codable {
    @DocumentID var uid: String?
    var name: String
    var username: String
    var email: String
    var birthday: String
    var biography: String?
    var createdAt: String?
    var profileImageURL: URL?
}
