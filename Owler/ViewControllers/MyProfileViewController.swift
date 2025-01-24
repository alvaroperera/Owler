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
                    if(myUser?.profileImageURL != nil){
                        ImagesManagerHelper.loadImageFrom(url: myUser!.profileImageURL!, imageView: self.myProfileImage)
                    } else {
                        ImagesManagerHelper.loadImageFrom(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/owlerapp-5969b.firebasestorage.app/o/user_profiles%2Fundefined%2FprofileImage.png?alt=media&token=586d28fe-e593-45ef-9b0d-60f1be89ce08")!, imageView: self.myProfileImage)
                    }
                    self.myPostListTableView.reloadData()
                }
            } catch {
                print("Error al obtener el usuario: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           // Crear la acción de eliminar
           let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { _, _, completionHandler in
               
               // 1. Obtén el ID del documento que deseas eliminar
               
               // 2. Llama a Firestore para eliminar el documento
               FirebaseFirestoreHelper.deletePost(postID: self.myPostItems[indexPath.row].postId!)
               
               self.myPostItems.remove(at: indexPath.row)
               self.myPostListTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
               
               // Notifica que la acción se completó
               completionHandler(true)
               self.loadMyProfileData()
           }
           
           // Devuelve la configuración de swipe con la acción de eliminar
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           return configuration
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPostDetailFromMyProfile" {
            if let indexPath = self.myPostListTableView.indexPathForSelectedRow {
                let post = myPostItems[indexPath.row]
                let destinationVC = segue.destination as? PostDetailViewController
                destinationVC!.post = post }
        }
        if segue.identifier == "goToEditMyProfile" {
            let destinationVC = segue.destination as? UserProfileEditFormTableViewController
            destinationVC!.user = self.myUser
        }
    }
}
