//
//  ApiManager.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 30.11.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class ApiManager {
  static let shared = ApiManager()
    
    private func configureDB() -> Firestore {
        var db: Firestore!
        var settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getPost(collection: String,
                  docName: String,
                  completion: @escaping (Document?) -> Void ) {
        let db = configureDB()
        db.collection(collection)
            .document(docName)
            .getDocument { qsnap, error in
                guard error == nil else { completion(nil); return }
                let doc = Document(field1: qsnap?.get("field1") as? String ?? "f1",
                                   field2: qsnap?.get("field2") as? String ?? "f2")
                completion(doc)
                
            }
        
    }
    
    func getImage(picName: String,
                  completion: @escaping (UIImage) -> Void ) {
        let store = Storage.storage()
        let reference = store.reference()
        let pathRef = reference.child("images")
        
        let  defaultImg = UIImage(named: "default")!
        let fileRef = pathRef.child(picName + ".jpg")
        fileRef.getData(maxSize: 1024*1024 ) { data, err in
            guard err == nil ,
            let data = data,
            let image = UIImage(data: data)
            else { completion(defaultImg); return }
            //print("done")
            completion(image)
            
        }
    }
    
}
