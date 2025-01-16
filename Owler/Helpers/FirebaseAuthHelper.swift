//
//  FirebaseAuthHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseAuth

class AuthHelper {
    
    func createUser(email: String, password: String, name: String, birthday: String) {
        // Crear el usuario en Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error al crear usuario: \(error.localizedDescription)")
                return
            }
            
            // El usuario se creó con éxito
            guard let user = result?.user else { return }
            
            // Crear una instancia de la clase User con los datos proporcionados
            let newUser = User(
                uid: user.uid,
                name: name,
                email: email,
                birthday: birthday
            )
            
            // Guardar los datos del usuario en Firestore
            
            FirestoreHelper.addUser(user: newUser)
        }
    }
}
