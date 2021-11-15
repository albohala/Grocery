//
//  HomeViewController.swift
//  grocery
//
//  Created by administrator on 14/11/2021.
//  Abdullah Albohalika

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController {
    
    
    /* Proporties */
    var itemsList = [GroceryItems]() // Empty string for the items
    
    var refObservers: [DatabaseHandle] = []
    
    let ref = Database.database().reference()
    
    let email = Auth.auth().currentUser?.email
    

    
    /* Table View */
    @IBOutlet weak var tableView: UITableView! // The table view in the storyboard
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        updateTable()
    }
    
    /* The add button */
    @IBAction func addButtonPressed(_ sender: Any) {
        askToEnterItem()
    }
    
    
/*********************************FUNCTIONS*********************************************/
    
    // Got this code online to save time. Source: https://programmingwithswift.com/add-uitextfield-to-uialertcontroller-with-swift/
    func askToEnterItem() {
        
        var textField = UITextField() // Create text field
        
        let email = Auth.auth().currentUser?.email // Get the user email
        
        // Create an alert to add item
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Submit button
        let submit = UIAlertAction(title: "Submit", style: .default, handler: { (submit) in
            //self.itemsList.append(textField.text!)
            
            guard let text = alert.textFields?.first?.text else { return }
            
            let newUser = ["item": textField.text, "user": email] // Save two values, the item the user entered and his email
            
            self.ref.child("Grocery").child(text).setValue(newUser) // Store those values in Firebase
            
            self.tableView.reloadData() // Update the table view

        })
        
        // Create a text field when the user hit +
        alert.addTextField { (text) in
            textField = text
            textField.placeholder = "Add Item"
        }
        
        alert.addAction(cancel)
        alert.addAction(submit)
        
        
        self.present(alert, animated: true) // Present the alert
        
    } // End of askToEnterItem function
    
    
    func updateTable() {
        // Fetch the data from Firebase
        ref.child("Grocery").observe(DataEventType.value, with: { (snapshot) in
            if snapshot .childrenCount > 0 { // if the snapshot has a value, then...
                self.itemsList.removeAll()
                
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    let itemsObject = items.value as? [String: AnyObject] // Treat it as dictionary that has
                    let itemsItem = itemsObject?["item"] // string item and
                    let itemsUser = itemsObject?["user"] // any type user
                    
                    let items = GroceryItems(item: itemsItem as! String?, user: itemsUser as! String?) // Update the list
                    
                    self.itemsList.append(items) // Append the list
                }
                
                self.tableView.reloadData() // Reload the table view
            }
        })
    } // End of updateTable function
    
    
    // In case the user wants to edit
    func updateItems(item: String, user: String) {
        let items = ["item": item, "user": user]
        
        ref.child(item).setValue(items)
    } // End of updateItem function
    
} // End of class

/**************************************************************************************************************/


// Extension to organize the table

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let item: GroceryItems
        
        item = itemsList[indexPath.row]
        print("This is item: \(item)")
        
        // Cell is subtitle type
        cell.textLabel?.text = item.item // Title
        cell.detailTextLabel?.text = item.user // Subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = itemsList[indexPath.row]

        let alert = UIAlertController(title: item.item, message: "Edit the entry by clicking on the edit button", preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Edit the cell
        let edit = UIAlertAction(title: "Edit", style: .default, handler: { (edit) in
            
            self.updateItems(item: item.item!, user: item.user!)
                
        })
        
        alert.addTextField{ (textField) in
            textField.text = item.item
        }

        alert.addAction(cancel)
        alert.addAction(edit)

        self.present(alert, animated: true)
    }
    
    // Slide to delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.itemsList.remove(at: indexPath.row)
            ref.child("Grocery").setValue(nil)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
} // End of extension

