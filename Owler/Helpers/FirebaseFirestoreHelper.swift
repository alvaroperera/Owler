//
//  FirebaseFirestoreHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseFirestore

class FirestoreHelper {
    
    static func addUser(user: User) {
        do {
            let db = Firestore.firestore()
            let documentData = try Firestore.Encoder().encode(user)
            
            db.collection("users").addDocument(data: documentData) { error in
                if let error = error {
                    print("Error al guardar el usuario: \(error.localizedDescription)")
                } else {
                    print("Usuario guardado con éxito.")
                }
            }
        } catch {
            print("Error al codificar el usuario: \(error.localizedDescription)")
        }
    }
}
