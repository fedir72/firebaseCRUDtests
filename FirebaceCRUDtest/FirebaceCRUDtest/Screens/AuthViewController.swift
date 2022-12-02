//
//  SignInViewController.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 30.11.2022.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    var userNow: User? {
        didSet {  print("User: \(userNow?.uid) , \(userNow?.phoneNumber)") }
    }

    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        print("auth button")
        guard let email = emailTextField.text,
              email.isEmpty == false,
              let pass = passwordTextField.text,
              pass.count > 5 else {
              self.someWrongAlert(
                "Attension!!!",
                " Password should be more than 5 characters")
                return
              }
        
        AuthService.shared.register(email: email, password: pass) { result in
            switch result {
            case .success(let user):
                print(user.email,user.uid)
            case .failure(let err):
                print("error of registration: \(err.localizedDescription)")
            }
        }
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              email.isEmpty == false,
              let pass = passwordTextField.text,
              pass.count > 5 else {
              self.someWrongAlert(
                "Attension!!!",
                " Password should be more than 5 characters")
                return
              }
        
        AuthService.shared.signIn(email: email,
                                  password: pass) { result in
            switch result {
            case .success(let res):
                self.userNow = res
            case .failure(let err):
                print("error of registration: \(err.localizedDescription)")
                
            }
        }
        self.passwordTextField.text = ""
        self.emailTextField.text = ""
        self.repeatPasswordTextfield.text = ""
    }
    
}
