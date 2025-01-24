//
//  ImagesManagerHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 24/1/25.
//

import SDWebImage

class ImagesManagerHelper {
    
    static func loadImageFrom(url: URL, imageView: UIImageView) {
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
}

