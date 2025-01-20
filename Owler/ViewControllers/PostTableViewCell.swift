//
//  PostTableViewCell.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var authorProfilePicImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postPreviewTextView: UITextView!
    @IBOutlet weak var authorUserNameLabel: UILabel!
    
    var author : User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(from post: Post) {
        
        
        Task(){
            do {
                self.author = try await FirestoreHelper.getUserInfo(uid: post.authorUid )
                
                DispatchQueue.main.async { [self] in
                    authorNameLabel.text = author?.name
                    authorUserNameLabel.text = "@\(author?.username ?? "")"
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
        postPreviewTextView.text = post.postBody
    }
}
