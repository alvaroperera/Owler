//
//  HomeViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items: [Post] = []
    
    @IBOutlet weak var postsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsListTableView.dataSource = self
        postsListTableView.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Will Appear")
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
            } catch {
                print("Error al obtener los posts: \(error)")
            }
        }
    }
    
    func simulateTabChange() {
        // Forzamos la ejecución del método viewWillAppear como si fuera un cambio de tab
        print("Pruebis")
        self.viewWillAppear(true) // Simula el comportamiento de un cambio de tab
        
        // Si también deseas llamar a viewDidAppear, puedes hacerlo también
        self.viewDidAppear(true)
    }
}
