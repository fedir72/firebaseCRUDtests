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

class FirestoreManager {
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
    private var carsRef: CollectionReference {
        return db.collection("cars")
    }
    private var foodRef: CollectionReference {
        return db.collection("food")
    }
    
    //MARK: - Posts CRUD
    func getPost(collection: String,
                 docName: String,
                 completion: @escaping (Document?) -> Void ) {
        db.collection(collection)
            .document(docName)
            .getDocument { qsnap, error in
                guard error == nil else { completion(nil); return }
                let doc = Document(field1: qsnap?.get("field1") as? String ?? "f1",
                                   field2: qsnap?.get("field2") as? String ?? "f2")
                completion(doc)
                
            }
        
    }
    
    //MARK: - Food CRUD
    
    func getFoodItems(completion: @escaping (Result<[FoodItem],Error>) -> Void) {
        self.foodRef.getDocuments { qsnap, error in
            if let error { completion(.failure(error)) }
            if let qsnap {
                var orders = [FoodItem]()
                for doc in qsnap.documents {
                    if var item = FoodItem(doc: doc) {
                        orders.append(item)
                    }
                    completion(.success(orders))
                }
            }
        }
    }
    
    func createFoodItem(foodItem: FoodItem,
                  completion: @escaping (Result<FoodItem,Error>) -> Void) {
        foodRef.document(foodItem.id).setData(foodItem.convertToFirestore) { error in
            if let error {
                completion(.failure(error))
            } else {
                //
                    completion(.success(foodItem))
                }
            }
        }
    
    func deleteFoodItem(by id: String, completion: @escaping (Error?) -> Void) {
        foodRef.document(id).delete() { err in
            if let err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateFood(by id: String,
                    num: Int,
                    price: Int,
                    completion: @escaping (Error?) -> ()) {
        let doc = db.document(id)
        doc.updateData([
             "numberOfItems": num,
            "price": price
        ]) { err in
            if let err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
  
}
