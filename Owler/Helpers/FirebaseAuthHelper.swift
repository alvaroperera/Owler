//
//  FirebaseAuthHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import FirebaseAuth
import UIKit

class FirebaseAuthHelper {
    
    static func createUser(email: String, password: String, name: String, username: String, birthday: String) {

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error al crear usuario: \(error.localizedDescription)")
                return
            }
            else {
                print("Usuario creado con éxito")
            }
            
            guard let user = result?.user else { return }
            
            let newUser = User(
                uid: user.uid,
                name: name,
                username: username,
                email: email,
                birthday: birthday
            )
            FirebaseFirestoreHelper.addUser(user: newUser)
        }
    }
    
    static func getCurrentUserUID() -> String? {
        guard let user = Auth.auth().currentUser else { return nil }
        
        return user.uid
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
            redirectToLogin()
            
        } catch let signOutError as NSError {
            print("Error al cerrar sesión: \(signOutError)")
        }
    }
    
    static func redirectToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
        let navigationController = UINavigationController(rootViewController: loginVC) // Envolver en UINavigationController

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = navigationController // Usar el UINavigationController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
