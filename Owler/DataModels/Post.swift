//
//  Post.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//

import FirebaseFirestore

struct Post: Codable {
    @DocumentID var postId: String?
    var postBody: String
    var likesCount: Int?
    var commentsCount: Int?
    var authorUid: String
    var publishedAt: String
}
