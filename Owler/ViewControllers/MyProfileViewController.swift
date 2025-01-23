//
//  MyProfileViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 22/1/25.
//

import UIKit

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myUsername: UILabel!
    @IBOutlet weak var myBiography: UITextView!
    @IBOutlet weak var myPostsNumber: UILabel!
    @IBOutlet weak var myFollowersNumber: UILabel!
    @IBOutlet weak var myFollowingNumber: UILabel!
    @IBOutlet weak var myProfileImage: UIImageView!
    @IBOutlet weak var myPostListTableView: UITableView!
    
    var myPostItems: [Post] = []
    var myUser: User?
    var myPosts: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPostListTableView.dataSource = self
        myPostListTableView.delegate = self
        loadMyProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMyProfileData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! PostTableViewCell
        cell.fillCell(from: self.myPostItems[indexPath.row])
        return cell
    }
    
    func loadMyProfileData() {
        Task {
            do {
                self.myUser = try await FirebaseFirestoreHelper.getUserInfo(uid: FirebaseAuthHelper.getCurrentUserUID()! )
                self.myPosts = try await FirebaseFirestoreHelper.getNumberOfPosts(uid: FirebaseAuthHelper.getCurrentUserUID()!)
                self.myPostItems = try await FirebaseFirestoreHelper.getPostsFromUser(uid: FirebaseAuthHelper.getCurrentUserUID()!)
                DispatchQueue.main.async { [self] in
                    myName.text = myUser?.name
                    myUsername.text = "@\(myUser!.username)"
                    myBiography.text = myUser?.biography
                    myPostsNumber.text = "\(myPosts ?? 0)"
                    myFollowersNumber.text = "\(myUser!.followersNumber ?? 0)"
                    myFollowingNumber.text = "\(myUser!.followingNumber ?? 0)"
                    self.myPostListTableView.reloadData()
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPostDetailFromMyProfile" {
            if let indexPath = self.myPostListTableView.indexPathForSelectedRow {
                let post = myPostItems[indexPath.row]
                let destinationVC = segue.destination as? PostDetailViewController
                destinationVC!.post = post }
        }
    }
}
