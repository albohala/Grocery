//
//  ProfileViewController.swift
//  grocery
//
//  Created by administrator on 14/11/2021.
//  Abdullah Albohalika



/* NOTE: the code below is fetched from the Messenger App assignment */

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    /* Proporties */
    let data = ["Log Out"] // Show in actionsheet
    
    
    /* Table View */
    @IBOutlet weak var tableView: UITableView! // Table view
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Cell
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
/****************************************************************************************************************************/
/********************************************* TABLE SETUP **********************************************************/

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // unhighlight the cell
        
        // show action sheet
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
             //action that is fired once selected
            
            guard let strongSelf = self else {
                return
            }
            // logout the user
            do {
                
                // Fetched online
                try Auth.auth().signOut()
                
                self?.dismiss(animated: true, completion: nil)

                // present login view controller
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
                print("Succeed loggin out")
            }
            catch {
                print("failed to logout")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    } // End didSelectRowAt function
/****************************************************************************************************************************/

} // End class
