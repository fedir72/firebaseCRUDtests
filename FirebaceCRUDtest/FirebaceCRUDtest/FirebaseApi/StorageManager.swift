//
//  StorageManager.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 04.12.2022.
//

import UIKit
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
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
