//
//  AuthManager.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 30.11.2022.
//

import Foundation
import FirebaseAuth

class AuthService {
    static var shared = AuthService()
    private init() { }
    
    private let auth = Auth.auth()
    var currentUser: User? {
        return auth.currentUser
    }
    
    func register(email: String,
                  password: String ,
                  completion: @escaping (Result<User,Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { res,err in
            if let res {
                print(res.user.email!)
                completion(.success(res.user))
            } else if let err {
                completion(.failure(err))
            }
            
        }
        
    }
    
    func signIn(email: String,
                password: String ,
                completion: @escaping (Result<User,Error>) -> ()) {
      auth.signIn(withEmail: email, password: password) { res,err in
          if let res {
              print(res.user.email!)
              completion(.success(res.user))
          } else if let err {
              completion(.failure(err))
          }
          
      }
  }
    
    func deleteCurrentUser(completion: @escaping (Error?) -> ()) {
        let user = auth.currentUser
        user?.delete { error in
          if let error {
            completion(error)
          } else {
            completion(nil)
          }
        }
    }
    
    
}
