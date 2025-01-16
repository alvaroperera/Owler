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
}
