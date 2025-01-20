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
        loadData()
        
    }
    
    func loadData() {
        Task(){
            do {
                self.author = try await FirestoreHelper.getUserInfo(uid: post!.authorUid )
                
                DispatchQueue.main.async { [self] in
                    authorNameLabell.text = author?.name
                    authorUsernameLabel.text = "@\(author?.username ?? "")"
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
        postTextView.text = post?.postBody
    }
}
