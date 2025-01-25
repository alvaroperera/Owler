//
//  UserProfileEditFormTableViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 24/1/25.
//

import UIKit

class UserProfileEditFormTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userBiographyTextView: UITextView!
    @IBOutlet weak var userUsernameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userBirthdayDatePicker: UIDatePicker!
    @IBOutlet weak var userBirthdayDisplaySwitch: UISwitch!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadMyProfileData()
    }
    
    @IBAction func changeProfileImage(_ sender: UITapGestureRecognizer) {
        selectImage()
    }
    @IBAction func logOut(_ sender: Any) {
        FirebaseAuthHelper.signOut()
    }
    
    func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.editedImage] as? UIImage {
            // Subir la imagen seleccionada
            FirebaseStorageHelper.uploadImageToStorage(image: selectedImage)
            loadMyProfileData()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfile(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: userBirthdayDatePicker.date)
        let tempUserInfo: User = User(uid: user!.uid, name: userNameTextField.text!, username: userUsernameTextField.text!, email: user!.email, birthday: dateString, biography: userBiographyTextView.text!, profileImageURL: user!.profileImageURL)
        FirebaseFirestoreHelper.updateUser(user: tempUserInfo)
        navigationController?.popViewController(animated: true)
    }
    func loadMyProfileData() {
        Task {
            do {
                self.user = try await FirebaseFirestoreHelper.getUserInfo(uid: FirebaseAuthHelper.getCurrentUserUID()! )
                DispatchQueue.main.async { [self] in
                    userNameTextField.text = user?.name
                    userUsernameTextField.text = "\(user!.username)"
                    userBiographyTextView.text = user?.biography
                    if(user?.profileImageURL != nil){
                        ImagesManagerHelper.loadImageFrom(url: user!.profileImageURL!, imageView: self.userProfileImageView)
                    } else {
                        ImagesManagerHelper.loadImageFrom(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/owlerapp-5969b.firebasestorage.app/o/user_profiles%2Fundefined%2FprofileImage.png?alt=media&token=586d28fe-e593-45ef-9b0d-60f1be89ce08")!, imageView: self.userProfileImageView)
                    }
                    self.tableView.reloadData()
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
    }
}
