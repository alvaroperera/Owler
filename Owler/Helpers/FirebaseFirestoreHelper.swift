//
//  FirebaseFirestoreHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseFirestore

class FirestoreHelper {
    
    static let db = Firestore.firestore()
    
    static func addUser(user: User) {
        do {
            try db.collection("users").document(user.uid!).setData(from: user) { error in
                if let error = error {
                    print("Error al guardar datos del usuario en Firestore: \(error.localizedDescription)")
                } else {
                    print("Usuario creado exitosamente en Firestore")
                }
            }
        } catch {
            print("Error al codificar datos del usuario: \(error.localizedDescription)")
        }
    }
    
    static func addPost(post: Post) {
        do {
            let documentData = try Firestore.Encoder().encode(post)
                    
            db.collection("posts").addDocument(data: documentData) { error in
                if let error = error {
                    print("Error al guardar el post: \(error.localizedDescription)")
                } else {
                    print("Post guardado con éxito.")
                }
            }
        } catch {
            print("Error al codificar el post: \(error.localizedDescription)")
        }
    }
    
    static func getPostsFromYourNetwork() async throws -> [Post] {
        let db = Firestore.firestore()
        var items: [Post] = []

        // Usamos Firestore con async/await
        let snapshot = try await db.collection("posts").getDocuments()
        
        do {
            items = try snapshot.documents.compactMap { document in
                try document.data(as: Post.self) // Decodifica los documentos a `Post`
            }
        } catch {
            print("Error al decodificar los datos: \(error)")
            throw error
        }

        return items
    }
}
