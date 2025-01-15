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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func createUser(email: String, password: String, name: String) {
        // Crear el usuario en Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error al crear usuario: \(error.localizedDescription)")
                return
            }
            
            // El usuario se creó con éxito
            guard let user = result?.user else { return }
            
            // Aquí se obtienen el UID y otros detalles para almacenarlos en Firestore
            let uid = user.uid
            let db = Firestore.firestore()
            
            // Crear un documento en Firestore con los datos del usuario
            let userRef = db.collection("users").document(uid)
            
            userRef.setData([
                "name": name,
                "email": email,
                "profilePicture": "",  // Puedes agregar la URL de la imagen si lo deseas
                "createdAt": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Error al crear usuario en Firestore: \(error.localizedDescription)")
                } else {
                    print("Usuario creado exitosamente en Firestore")
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

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
