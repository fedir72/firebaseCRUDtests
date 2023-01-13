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
    let stor = Storage.storage().reference().child("images")
    
    func getImage(picName: String,
                  completion: @escaping (UIImage) -> Void ) {
        let  defaultImg = UIImage(named: "default")!
        let fileRef = stor.child(picName + ".jpg")
        fileRef.getData(maxSize: 1024*1024 ) { data, err in
            guard err == nil ,
            let data = data,
            let image = UIImage(data: data)
            else { completion(defaultImg); return }
            //print("done")
            completion(image)
            
        }
    }
    
    func uploadImage(image: UIImage, completion:@escaping (Result<URL,Error>) -> ()) {
        let ref = stor.child(UUID().uuidString)
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.putData(imageData,
                    metadata: metaData) { meta, error in
            if let error {
                completion(.failure(error))
            } else if let _ = meta {
                ref.downloadURL { url, err in
                    guard let url else { completion(.failure(err!)); return }
                    completion(.success(url))
                }
            }
        }
    }
}
