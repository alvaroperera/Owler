//
//  Log_In_ViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 14/1/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInWithEmail(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error al iniciar sesión: \(error.localizedDescription)")
            } else {
                print("Sesión iniciada como: \(authResult?.user.email ?? "")")
                // self.performSegue(withIdentifier: "goToMainMenu", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(self.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
}
