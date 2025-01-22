//
//  MyProfileViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 22/1/25.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myUsername: UILabel!
    @IBOutlet weak var myBiography: UITextView!
    @IBOutlet weak var myPostsNumber: UILabel!
    @IBOutlet weak var myFollowersNumber: UILabel!
    @IBOutlet weak var myFollowingNumber: UILabel!
    @IBOutlet weak var myProfileImage: UIImageView!
    
    var myUser: User?
    var myPosts: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMyProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMyProfileData()
    }
    
    func loadMyProfileData() {
        Task {
            do {
                self.myUser = try await FirebaseFirestoreHelper.getUserInfo(uid: FirebaseAuthHelper.getCurrentUserUID()! )
                self.myPosts = try await FirebaseFirestoreHelper.getMyNumberOfPosts(uid: FirebaseAuthHelper.getCurrentUserUID()!)
                DispatchQueue.main.async { [self] in
                    myName.text = myUser?.name
                    myUsername.text = "@\(myUser!.username)"
                    myBiography.text = myUser?.biography
                    myPostsNumber.text = "\(myPosts ?? 0)"
                    myFollowersNumber.text = "\(myUser!.followersNumber ?? 0)"
                    myFollowingNumber.text = "\(myUser!.followingNumber ?? 0)"
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
    }
}
