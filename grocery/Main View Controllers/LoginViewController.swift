//
//  LoginViewController.swift
//  grocery
//
//  Created by administrator on 13/11/2021.
//  Abdullah Albohalika

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    /* Proporties */
    let ref = Database.database().reference() // Fetched from Firebase docs
    
    
    /* Text fields */
    @IBOutlet weak var emailTextField: UITextField! // Text field for the email
    @IBOutlet weak var passwordTextField: UITextField! // Text field for the password
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField?.isSecureTextEntry = true // Hide the password
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // These should empty the text fields when logged out, but it's not working
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLoggedIn()
    }
    
    
/****************************************************************************************************************************/
    
    //MARK: Login and sign up buttons
    
    /* The Log In Button */
    @IBAction func logInButtonPressed(_ sender: Any) {
        // Check if the text fields are empty and send an alert to the user if they are
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        logIn()
    }
    
    
    /* The Sign Up Button */
    @IBAction func signUpButtonPressed(_ sender: Any) {
        // Check if the text fields are empty and send an alert to the user if they are
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        signUp()
    }
    
    
/********************************************* FUNCTIONS **********************************************************/
/****************************************************************************************************************************/
    
    //MARK: Sign up function
    func signUp() {
        // Fetched from Firebase docs
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Error \(String(describing: error?.localizedDescription))")
                self.userExist()
                return
            }
            
            // Transition to the main app after signing up
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "appStoryboard")
            vc?.modalTransitionStyle = .crossDissolve
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true)
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            ref.child("Users").child(uid).setValue(["email": emailTextField.text])
            
        } // End of Auth.
    } // End signUp function
    
    
    
    //MARK: Login function
    func logIn() {
        
        let defaults = UserDefaults.standard
        
        // Fetched from Firebase docs
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            guard self != nil else { return }
            if let error = error {
                print(error.localizedDescription)
                self?.userDoesNotExist()
            }
            
            if Auth.auth().currentUser != nil {
                print("Auth user: ", Auth.auth().currentUser?.uid as Any) // Fetched from Firebase docs
                
                // Transition to the main app after logging in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "appStoryboard")
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
            
            defaults.set(true, forKey: "isLoggedIn") // Keep the user logged in
            
        } // End of Auth.
    } // End of logIn function
    
    
    // Keep the user logged in
    func isLoggedIn() {
        if Auth.auth().currentUser != nil {
            print("Auth user: ", Auth.auth().currentUser?.uid as Any) // Fetched from Firebase docs
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "appStoryboard")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }

    
/****************************************************************************************************************************/
    
    //MARK: Check user validity functions
    
    func alertUserLoginError() { // Appear when the user missed something in the text fields
        let alert = UIAlertController(title: "Error", message: "Please enter all information to login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func userDoesNotExist() { // Appear when the user try to log in but the data doesn't exist
        let alert = UIAlertController(title: "Error", message: "User does not exist. Please try to sign up instead", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func userExist() { // Appear when the user already exists
        let alert = UIAlertController(title: "Error", message: "User already exist. Try to log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
} // End of class
