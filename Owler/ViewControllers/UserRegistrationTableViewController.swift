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
    
    var tableFormData = [] as [Any]
    
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
    
    @IBAction func saveUser(_ sender: UIBarButtonItem) {
        print("Prueba texto")
        // Acceder a la celda "nombreCelda"
            if let nombreCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)),
               nombreCell.reuseIdentifier == "nombreCelda" {
                nombreCell.textLabel?.text = "Nombre: Álvaro"
            }
            
            // Acceder a la celda "emailCelda"
            if let emailCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
               emailCell.reuseIdentifier == "emailCelda" {
                emailCell.detailTextLabel?.text = "Correo: usuario@ejemplo.com"
            }
            
            // Acceder a la celda "guardarCelda" en la sección 1
            if let guardarCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)),
               guardarCell.reuseIdentifier == "guardarCelda" {
                guardarCell.textLabel?.text = "Guardar cambios"
            }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Campos obligatorios", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func createUser(email: String, password: String, name: String) {
        
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
