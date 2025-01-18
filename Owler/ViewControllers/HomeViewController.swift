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
        
        
        loadData()
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
        return cell
    }
    
    func loadData() {
        Task() {
            do {
                self.items = try await FirestoreHelper.getPostsFromYourNetwork()
                self.postsListTableView.reloadData()
                
                DispatchQueue.main.async {
                    self.postsListTableView.reloadData()
                }
            } catch {
                print("Error al obtener los posts: \(error)")
            }
        }
    }
}
