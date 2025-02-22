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
        
        
        Task {
            do {
                self.author = try await FirebaseFirestoreHelper.getUserInfo(uid: post.authorUid )
                
                DispatchQueue.main.async { [self] in
                    let authorInfoString = "\(author!.name) @\(author!.username)"
                    let attributedString = NSMutableAttributedString(string: authorInfoString)
                    
                    let boldFont = UIFont.boldSystemFont(ofSize: authorNameLabel.font.pointSize)
                    let boldAttributes: [NSAttributedString.Key: Any] = [
                        .font: boldFont
                    ]
                    if let boldRange = authorInfoString.range(of: author!.name) {
                        let nsRange = NSRange(boldRange, in: authorInfoString)
                        attributedString.addAttributes(boldAttributes, range: nsRange)
                    }
                    authorNameLabel.attributedText = attributedString
                    postPreviewTextView.text = post.postBody
                    if author!.profileImageURL != nil {
                        ImagesManagerHelper.loadImageFrom(url: author!.profileImageURL!, imageView: self.authorProfilePicImageView)
                    } else {
                        ImagesManagerHelper.loadImageFrom(url: URL( string: "https://firebasestorage.googleapis.com/v0/b/owlerapp-5969b.firebasestorage.app/o/user_profiles%2Fundefined%2FprofileImage.png?alt=media&token=586d28fe-e593-45ef-9b0d-60f1be89ce08")!, imageView: self.authorProfilePicImageView)
                    }
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
    }
}
