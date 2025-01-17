//
//  CreatePostViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//
import UIKit

class CreatePostViewController: UIViewController {
    
    var currentUser: User?
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPost(_ sender: UIButton) {
        
        let currentUserUid = FirebaseAuthHelper.getCurrentUserUID()
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentDate)
        FirestoreHelper.addPost(post: Post(
            postBody: postTextView.text,
            authorUid: currentUserUid!,
            publishedAt: dateString
        ))
        postTextView.text = "¿Qué te gustaría postear"
        dismiss(animated: true) {
            // Obtener el HomeViewController y llamar a la simulación de cambio de tab
            if let homeVC = self.presentingViewController as? HomeViewController {
                // Simulamos el cambio de tab y la recarga de datos
                homeVC.simulateTabChange()
                print("Modal cerrada, recargando datos en HomeViewController...")
            }
        }
    }
}
