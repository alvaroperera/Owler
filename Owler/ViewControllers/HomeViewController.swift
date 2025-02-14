//
//  HomeViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items: [Post] = []
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var postsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsListTableView.dataSource = self
        postsListTableView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Recargando publicaciones...") // Texto opcional
        refreshControl.addTarget(self, action: #selector(reloadController), for: .valueChanged)
        postsListTableView.refreshControl = refreshControl
    }
    
    @objc func reloadController() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.refreshControl.endRefreshing()
            
            // Reinstancia el controlador actual
            if let currentViewController = self?.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                self?.navigationController?.setViewControllers([currentViewController], animated: false)
            }
        }
    }
    func reloadView() {
        // Código de inicialización
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.fillCell(from: self.items[indexPath.row])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        cell.authorProfilePicImageView.addGestureRecognizer(tapGesture)
        cell.authorProfilePicImageView.isUserInteractionEnabled = true
        cell.authorProfilePicImageView.tag = indexPath.row // Usa el tag para identificar la celda
        return cell
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            let indexPathRow = imageView.tag
            let post = items[indexPathRow]
            let currentUserUID = FirebaseAuthHelper.getCurrentUserUID()!
            if currentUserUID != post.authorUid {
                performSegue(withIdentifier: "goToAuthorProfile", sender: post.authorUid)
            }
            else {
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 1
                }
            }
            
        }
    }
    
    
    func loadData() {
        Task{
            do {
                self.items = try await FirebaseFirestoreHelper.getPostsFromYourNetwork()
                DispatchQueue.main.async {
                    self.postsListTableView.reloadData()
                }
            } catch {
                print("Error al obtener los posts: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPostDetail" {
            if let indexPath = self.postsListTableView.indexPathForSelectedRow {
                let post = items[indexPath.row]
                let destinationVC = segue.destination as? PostDetailViewController
                destinationVC!.post = post }
        }
        
        if segue.identifier == "goToAuthorProfile",
           let destinationVC = segue.destination as? ProfileViewController,
           let data = sender as? String { // Cambia el tipo si estás pasando un objeto más complejo
            destinationVC.userUid = data
        }
    }
}
