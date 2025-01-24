//
//  CreatePostViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//
import UIKit

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    var currentUser: User?
    var previewPostText: String = "¿Qué tal va todo?"
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        postTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        postTextView.text = previewPostText
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ postTextView: UITextView) {
        postTextView.text.removeAll()
    }
    
    @IBAction func createPost(_ sender: UIButton) {
        
        let currentUserUid = FirebaseAuthHelper.getCurrentUserUID()
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentDate)
        FirebaseFirestoreHelper.addPost(post: Post(
            postBody: postTextView.text,
            authorUid: currentUserUid!,
            publishedAt: dateString
        ))
        postTextView.text = previewPostText
        dismiss(animated: true)
    }
    func loadData() {
        Task {
            do {
                if let currentUserUid = FirebaseAuthHelper.getCurrentUserUID() {
                    self.currentUser = try await FirebaseFirestoreHelper.getUserInfo(uid: currentUserUid)
                    DispatchQueue.main.async{
                        if(self.currentUser?.profileImageURL != nil){
                            ImagesManagerHelper.loadImageFrom(url: self.currentUser!.profileImageURL!, imageView: self.userProfileImg)
                        } else {
                            ImagesManagerHelper.loadImageFrom(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/owlerapp-5969b.firebasestorage.app/o/user_profiles%2Fundefined%2FprofileImage.png?alt=media&token=586d28fe-e593-45ef-9b0d-60f1be89ce08")!, imageView: self.userProfileImg)
                        }
                    }
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
    }
}
