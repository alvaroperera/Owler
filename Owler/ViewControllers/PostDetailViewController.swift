//
//  PostDetailViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 20/1/25.
//

import UIKit
class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var authorNameLabell: UILabel!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    
    var post: Post?
    var author: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.hidesBackButton = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func loadData() {
        Task(){
            do {
                self.author = try await FirebaseFirestoreHelper.getUserInfo(uid: post!.authorUid )
                
                DispatchQueue.main.async { [self] in
                    authorNameLabell.text = author?.name
                    authorUsernameLabel.text = "@\(author?.username ?? "")"
                    if(author?.profileImageURL != nil){
                        ImagesManagerHelper.loadImageFrom(url: author!.profileImageURL!, imageView: self.authorProfileImageView)
                    } else {
                        ImagesManagerHelper.loadImageFrom(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/owlerapp-5969b.firebasestorage.app/o/user_profiles%2Fundefined%2FprofileImage.png?alt=media&token=586d28fe-e593-45ef-9b0d-60f1be89ce08")!, imageView: self.authorProfileImageView)
                    }
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
        postTextView.text = post?.postBody
    }
}
