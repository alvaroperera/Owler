//
//  SearchUserTableViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 25/1/25.
//

import UIKit

class SearchUserTableViewController: UITableViewController, UIGestureRecognizerDelegate, UISearchBarDelegate {
    
    @IBOutlet var usersSearchTableView: UITableView!
    var usersList: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        usersSearchTableView.dataSource = self
        usersSearchTableView.delegate = self
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.usersList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchUserItemCell
        let searchResponse = usersList[indexPath.row]
        cell.fillCell(with: searchResponse)
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            searchUserBy(username: query)
        } else {
            //loadFirstData()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func searchUserBy(username: String){
        Task {
            do {
                self.usersList = try await FirebaseFirestoreHelper.getUsersByUsername(username: username)
                DispatchQueue.main.async {
                    self.usersSearchTableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileFromSearchItem" {
            if let indexPath = self.usersSearchTableView.indexPathForSelectedRow {
                let user = usersList[indexPath.row]
                let destinationVC = segue.destination as? ProfileViewController
                destinationVC!.userUid = user.uid }
        }
    }
}
