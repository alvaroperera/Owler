//
//  SearchUserItemCell.swift
//  Owler
//
//  Created by Álvaro Perera on 29/1/25.
//

import UIKit

class SearchUserItemCell: UITableViewCell {
    
    @IBOutlet weak var userProfilePicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(with user: User) {
                
        let authorInfoString = "\(user.name) @\(user.username)"
            let attributedString = NSMutableAttributedString(string: authorInfoString)
            
            let boldFont = UIFont.boldSystemFont(ofSize: userNameLabel.font.pointSize)
            let boldAttributes: [NSAttributedString.Key: Any] = [
                .font: boldFont
            ]
        if let boldRange = authorInfoString.range(of: user.name) {
                let nsRange = NSRange(boldRange, in: authorInfoString)
                attributedString.addAttributes(boldAttributes, range: nsRange)
            }
            userNameLabel.attributedText = attributedString
        if user.profileImageURL != nil {
            ImagesManagerHelper.loadImageFrom(url: user.profileImageURL!, imageView: self.userProfilePicImageView)
            } else {
                ImagesManagerHelper.loadImageFrom(url: URL( string: "https://firebasestorage.googleapis.com/v0/b/owlerapp-5969b.firebasestorage.app/o/user_profiles%2Fundefined%2FprofileImage.png?alt=media&token=586d28fe-e593-45ef-9b0d-60f1be89ce08")!, imageView: self.userProfilePicImageView)
            }
    }

}
