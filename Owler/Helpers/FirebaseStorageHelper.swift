//
//  FirebaseStorageHelper.swift
//  Owler
//
//  Created by Álvaro Perera on 24/1/25.
//

import FirebaseStorage
import UIKit

class FirebaseStorageHelper {
    
    static func uploadImageToStorage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        guard let userID = FirebaseAuthHelper.getCurrentUserUID() else { return }
        let storageRef = Storage.storage().reference().child("user_profiles/\(userID)/profileImage.jpg")
        

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error al subir la imagen: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error al obtener la URL de descarga: \(error.localizedDescription)")
                    return
                }
                if let downloadURL = url {
                    print("URL de la imagen subida: \(downloadURL.absoluteString)")
                    FirebaseFirestoreHelper.saveProfileImageURL(url: downloadURL.absoluteString)
                }
            }
        }
    }
}
