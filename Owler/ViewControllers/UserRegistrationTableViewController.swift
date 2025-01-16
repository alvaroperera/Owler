//
//  UserRegistrationTableViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 15/1/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserRegistrationTableViewController: UITableViewController {
    
    var userDataToBegin = [] as [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    @IBAction func saveNewUser(_ sender: UIBarButtonItem) {
        guard let emailCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)),
              let passwordCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
              let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)),
              let usernameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)),
              let birthdayCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1))
        else {
            return
        }
        if let emailTextField = emailCell.viewWithTag(1) as? UITextField,
           let passwordTextField = passwordCell.viewWithTag(5) as? UITextField,
           let nameTextField = nameCell.viewWithTag(2) as? UITextField,
           let usernameTextField = usernameCell.viewWithTag(3) as? UITextField,
           let birthdayDatePicker = birthdayCell.viewWithTag(4) as? UIDatePicker {
            
            let email = emailTextField.text ?? ""
            let name = nameTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let username = usernameTextField.text ?? ""
            let birthday = birthdayDatePicker.date
            
            
            if email.isEmpty || name.isEmpty || username.isEmpty {
                showAlert(message: "Por favor, rellena todos los campos para guardar el evento")
                return
            }
            
            print("Email: \(email), Password: \(password) Name: \(name), Username: \(username), Fecha: \(birthday)")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: birthday)
            
            FirebaseAuthHelper.createUser(email: email, password: password, name: name, username: username, birthday: dateString)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Campos obligatorios", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
