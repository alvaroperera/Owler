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
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func logInWithEmail(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showLoginError(error: error)
            } else {
                print("Sesión iniciada como: \(authResult?.user.email ?? "")")
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        errorLabel.isHidden = true
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
    
    func showLoginError(error: Error) {
        // Configura el mensaje de error
        errorLabel.text = error.localizedDescription
        errorLabel.textColor = .red
        errorLabel.isHidden = false
        highlightTextFieldsWithError()
        shakeTextField(emailTextField)
        shakeTextField(passwordTextField)
    }
    
    func shakeTextField(_ textField: UITextField) {
        // Configurar la animación de "shake"
        let animation = CAKeyframeAnimation(keyPath: "position")
        let x = textField.center.x
        let y = textField.center.y
        animation.values = [
            CGPoint(x: x - 10, y: y), // Izquierda
            CGPoint(x: x + 10, y: y), // Derecha
            CGPoint(x: x - 10, y: y), // Izquierda
            CGPoint(x: x + 10, y: y), // Derecha
            CGPoint(x: x, y: y)       // Posición original
        ]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1] // Tiempos clave de la animación
        animation.duration = 0.3 // Duración total

        // Añadir la animación a la capa del campo de texto
        textField.layer.add(animation, forKey: "shake")
    }
    
    func highlightTextFieldsWithError() {
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 5.0

        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 5.0
    }
}
