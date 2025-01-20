//
//  CreatePostViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//
import UIKit

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    var currentUser: User?
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        postTextView.text = "¿Qué te gustaría postear"
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ postTextView: UITextView) {
        postTextView.text.removeAll()
        // Aquí puedes ejecutar el código que desees.
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
        dismiss(animated: true)
    }
}
