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
    
    var userPostItems: [Post] = []
    var userUid: String?
    var user: User?
    var userPosts: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPostListTableView.dataSource = self
        userPostListTableView.delegate = self
        loadUserProfileData()
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
    
    func loadUserProfileData() {
        Task {
            do {
                print(self.userUid!)
                self.user = try await FirebaseFirestoreHelper.getUserInfo(uid: self.userUid! )
                self.userPosts = try await FirebaseFirestoreHelper.getNumberOfPosts(uid: self.userUid!)
                self.userPostItems = try await FirebaseFirestoreHelper.getPostsFromUser(uid: self.userUid!)
                DispatchQueue.main.async { [self] in
                    userName.text = user?.name
                    userUserName.text = "@\(user!.username)"
                    userBiography.text = user?.biography
                    userPostsNumber.text = "\(userPosts ?? 0)"
                    userFollowersNumber.text = "\(user!.followersNumber ?? 0)"
                    userFollowingNumber.text = "\(user!.followingNumber ?? 0)"
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
