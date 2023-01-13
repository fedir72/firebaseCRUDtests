//
//  SignInViewController.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 30.11.2022.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    
    
    var registrationState = false {
        didSet {
            changeUI(by: registrationState)
        }
    }
    
    var userNow: User? {
        didSet {  print("User: \(userNow!.uid) , \(String(describing: userNow!.phoneNumber))") }
    }


    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        loginButton.layer.cornerRadius = 25
        if AuthService.shared.currentUser == nil {
            registrationState = true
        } else {
            self.repeatPasswordTextfield.alpha = 0
            self.repeatPasswordTextfield.isEnabled = false
        }
    }

    @IBAction func registerSwitch(_ sender: UISwitch) {
        self.registrationState.toggle()
    }
    
    
   
    
    
   
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        switch registrationState {
            
        case true:
            guard let email = emailTextField.text,
                  email.isEmpty == false,
                  let pass = passwordTextField.text,
                  pass.count > 5 else {
                  self.someWrongAlert(
                    "Attension!!!",
                    " Password should be more than 5 characters",
                  completion: {})
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
            self.registrationState = false
        case false:
            guard let email = emailTextField.text,
                  email.isEmpty == false,
                  let pass = passwordTextField.text,
                  pass.count > 5 else {
                  self.someWrongAlert(
                    "Attension!!!",
                    " Password should be more than 5 characters",
                    completion: {})
                    return
                  }
            
            AuthService.shared.signIn(email: email,
                                      password: pass) { result in
                switch result {
                case .success(let res):
                    self.userNow = res
                case .failure(let err):
                    print("error of logging: \(err.localizedDescription)")
                    
                }
            }
        }

        emtyFields()
    }
    
}

private extension AuthViewController {
    
    func emtyFields() {
        self.passwordTextField.text = ""
        self.emailTextField.text = ""
        self.repeatPasswordTextfield.text = ""
    }
    
    func changeUI(by state: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            switch state {
                
            case true:
                self.loginButton.backgroundColor = .red
                self.loginButton.setTitle("Register", for: .normal)
                self.repeatPasswordTextfield.alpha = 1
                self.repeatPasswordTextfield.isEnabled = true
            case false:
                self.loginButton.backgroundColor = .systemBlue
                self.loginButton.setTitle("Log in", for: .normal)
                self.repeatPasswordTextfield.alpha = 0
                self.repeatPasswordTextfield.isEnabled = false
            }
            
          
        }
    }
}
