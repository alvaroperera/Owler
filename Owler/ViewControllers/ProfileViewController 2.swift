//
//  ProfileViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 23/1/25.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userPostListTableView: UITableView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var userBiography: UITextView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userUserName: UILabel!
    @IBOutlet weak var userPostsNumber: UILabel!
    @IBOutlet weak var userFollowersNumber: UILabel!
    @IBOutlet weak var userFollowingNumber: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userBirthday: UILabel!
    
    
    var userPostItems: [Post] = []
    var userUid: String?
    var user: User?
    var userPosts: Int?
    var userFollows: Int?
    var userFollowers: Int?
    var isFollow: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPostListTableView.dataSource = self
        userPostListTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfileData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! PostTableViewCell
        cell.fillCell(from: self.userPostItems[indexPath.row])
        return cell
    }
    
    
    /*
    @IBAction func followOrUnfollow(_ sender: UIButton) {
        print(self.isFollow as Any)
        if (self.isFollow ?? false == false ){
            FirebaseFirestoreHelper.addFollow(follow: Follow(
                userID: FirebaseAuthHelper.getCurrentUserUID()!,
                userFollowedID: self.userUid!))
            self.isFollow = true
            
        }
        else {
            Task {
                do {
                    try await FirebaseFirestoreHelper.removeFollow(uid: FirebaseAuthHelper.getCurrentUserUID()!, followedUid: self.userUid!)
                } catch {
                    print("Error al eliminar el documento: \(error.localizedDescription)")
                }
            }
        }
        loadUserProfileData()
    }*/
    
    func loadUserProfileData() {
        Task {
            do {
                self.user = try await FirebaseFirestoreHelper.getUserInfo(uid: self.userUid! )
                self.userPosts = try await FirebaseFirestoreHelper.getNumberOfPosts(uid: self.userUid!)
                self.userFollows = try await FirebaseFirestoreHelper.getNumberOfFollows(uid: self.userUid!)
                self.userFollowers = try await FirebaseFirestoreHelper.getNumberOfFollowers(uid: self.userUid!)
                self.userPostItems = try await FirebaseFirestoreHelper.getPostsFromUser(uid: self.userUid!)
                let birthdayText = OwlerToolsHelper.dateFullTextString(fechaEnString: self.user!.birthday)
                print(self.isFollow as Any)
                DispatchQueue.main.async { [self] in
                    userName.text = user?.name
                    userUserName.text = "@\(user!.username)"
                    userBiography.text = user?.biography
                    userPostsNumber.text = "\(userPosts ?? 0)"
                    userFollowersNumber.text = "\(userFollowers ?? 0)"
                    userFollowingNumber.text = "\(userFollows ?? 0)"
                    userBirthday.text = birthdayText
                    if(user?.profileImageURL != nil){
                        ImagesManagerHelper.loadImageFrom(url: user!.profileImageURL!, imageView: self.userProfileImage)
                    } else {
                        ImagesManagerHelper.loadImageFrom(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/owlerapp-5969b.firebasestorage.app/o/user_profiles%2Fundefined%2FprofileImage.png?alt=media&token=586d28fe-e593-45ef-9b0d-60f1be89ce08")!, imageView: self.userProfileImage)
                    }
                    self.userPostListTableView.reloadData()
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPostDetailFromUserProfile" {
            if let indexPath = self.userPostListTableView.indexPathForSelectedRow {
                let post = userPostItems[indexPath.row]
                let destinationVC = segue.destination as? PostDetailViewController
                destinationVC!.post = post }
        }
    }
}
