//
//  FirebaseAuthHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseAuth

class FirebaseAuthHelper {
    
    func createUser(email: String, password: String, name: String, username: String, birthday: String) {

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error al crear usuario: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            let newUser = User(
                uid: user.uid,
                name: name,
                username: username,
                email: email,
                birthday: birthday
            )
            FirestoreHelper.addUser(user: newUser)
        }
    }
}
