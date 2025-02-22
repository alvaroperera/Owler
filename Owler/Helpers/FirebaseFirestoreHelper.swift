//
//  FirebaseFirestoreHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseFirestore

class FirebaseFirestoreHelper {
    
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
    
    static func addFollow(follow: Follow) {
        do {
            let documentData = try Firestore.Encoder().encode(follow)
                    
            db.collection("follows").addDocument(data: documentData) { error in
                if let error = error {
                    print("Error al guardar el post: \(error.localizedDescription)")
                } else {
                    print("Follow guardado con éxito.")
                }
            }
        } catch {
            print("Error al codificar el follow: \(error.localizedDescription)")
        }
    }
    
    static func removeFollow(uid: String, followedUid: String) async throws {
        do {
            let querySnapshot = try await db.collection("follows")
                .whereField("uid", isEqualTo: uid)
                .whereField("userFollowedID", isEqualTo: followedUid)
                .getDocuments()
            
            guard !querySnapshot.documents.isEmpty else {
                print("No se encontraron documentos para eliminar.")
                return
            }
            for document in querySnapshot.documents {
                try await document.reference.delete()
                print("Documento eliminado correctamente: \(document.documentID)")
            }
            } catch {
                print("Error al eliminar el documento: \(error.localizedDescription)")
                throw error
            }
    }
    
    static func getPostsFromYourNetwork() async throws -> [Post] {
        var items: [Post] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let snapshot = try await db.collection("posts").getDocuments()

        do {
            items = try snapshot.documents.compactMap { document in
                try document.data(as: Post.self)
            }
            
            items.sort { post1, post2 in
                guard
                    let date1 = dateFormatter.date(from: post1.publishedAt),
                    let date2 = dateFormatter.date(from: post2.publishedAt)
                else {
                    return false
                }
                return date1 > date2
            }
        } catch {
            print("Error al decodificar los datos: \(error)")
            throw error
        }

        return items
    }
    
    static func getNumberOfPosts(uid: String) async throws -> Int {
        let snapshot = try await db.collection("posts").whereField("authorUid", isEqualTo: uid).getDocuments()
        return snapshot.count
    }
    
    static func getNumberOfFollows(uid: String) async throws -> Int {
        let snapshot = try await db.collection("follows").whereField("userUid", isEqualTo: uid).getDocuments()
        return snapshot.count
    }
    
    static func getNumberOfFollowers(uid: String) async throws -> Int {
        let snapshot = try await db.collection("followers").whereField("userUid", isEqualTo: uid).getDocuments()
        return snapshot.count
    }
    
    static func getFollowsFromUser(uid: String) async throws -> [Follow] {
        var items: [Follow] = []
        
        let snapshot = try await db.collection("follows").whereField("userUid", isEqualTo: uid).getDocuments()
        
        do {
            items = try snapshot.documents.compactMap { document in
                try document.data(as: Follow.self)
            } 
        } catch {
            print("Error al decodificar los datos: \(error)")
            throw error
        }
        return items
    }
    
    static func isFollowingUser(uid: String, followedUid: String) async throws -> Bool {
        let snapshot = try await db.collection("follows").whereField("userUid", isEqualTo: uid).whereField("userFollowedID", isEqualTo: followedUid).getDocuments()
        
        return snapshot.count > 0
    }
    
    static func getUsersByUsername(username: String) async throws -> [User] {
        var items: [User] = []
        
        let snapshot = try await db.collection("users")
            .order(by: "username")
            .start(at: [username])
            .end(at: ["\(username)\u{f8ff}"])
            .getDocuments()
        do {
            items = try snapshot.documents.compactMap { document in
                try document.data(as: User.self)
            }
        } catch {
            print("Error al decodificar los datos: \(error)")
            throw error
        }
        return items
    }
    
    static func updateUser(user: User) {
        do{
            try db.collection("users").document(user.uid!).setData(from: user)
        } catch {
            print("Error al actualizar el usuario")
        }
    }
    
    static func getPostsFromUser(uid: String) async throws -> [Post] {
        var items: [Post] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let snapshot = try await db.collection("posts").whereField("authorUid", isEqualTo: uid).getDocuments()
        
        do {
            items = try snapshot.documents.compactMap { document in
                try document.data(as: Post.self)
            }
            items.sort { post1, post2 in
                guard
                    let date1 = dateFormatter.date(from: post1.publishedAt),
                    let date2 = dateFormatter.date(from: post2.publishedAt)
                else {
                    return false
                }
                return date1 > date2
            }
        } catch {
            print("Error al decodificar los datos: \(error)")
            throw error
        }
        return items
    }
    
    static func getUserInfo(uid: String) async throws -> User {
        var user: User?
        let snapshot = try await db.collection("users").document(uid).getDocument()
        do {
            user = try snapshot.data(as: User.self)
        } catch {
            print("Error al decodificar los datos: \(error)")
            throw error
        }
        return user!
    }
    
    static func deletePost(postID: String) {
        db.collection("posts").document(postID).delete { error in
            if let error = error {
                print("Error eliminando el documento: \(error.localizedDescription)")
            } else {
                print("Documento eliminado correctamente.")

            }
        }
    }
    
    static func saveProfileImageURL(url: String) {
        guard let userID = FirebaseAuthHelper.getCurrentUserUID() else { return }
        
        db.collection("users").document(userID).updateData(["profileImageURL": url]) { error in
            if let error = error {
                print("Error al guardar la URL de la imagen: \(error.localizedDescription)")
            } else {
                print("URL de la imagen guardada correctamente en Firestore")
            }
        }
    }
}
