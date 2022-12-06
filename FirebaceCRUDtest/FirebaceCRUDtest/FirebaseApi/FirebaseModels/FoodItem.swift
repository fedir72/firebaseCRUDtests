//
//  FoodItem.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 04.12.2022.
//

import Foundation
import FirebaseFirestore

struct FoodItem {
    var id: String
    var name: String
    var numberOfItems: Int
    var price: Int
    
    var cost: Int {
        return price*numberOfItems
    }
    
    var sumText: String {
        return """
               id: \(id)
               num: \(numberOfItems)kg
               price: \(price)
               sum: \(cost)
               """
    }
    
    
    var convertToFirestore: [String: Any] {
        return [
            "id": id,
            "name": name,
            "numberOfItems": numberOfItems,
            "price": price
        ]
    }
    
    init(id: String?, name: String, numberOfItems: Int, price: Int) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.numberOfItems = numberOfItems
        self.price = price
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else { return nil }
        guard let name = data["name"] as? String else { return nil }
        guard let numberOfItems = data["numberOfItems"] as? Int else { return nil }
        guard let price = data["price"] as? Int else { return nil }
//        let product = FoodItem(id: id,
//                               name: name,
//                               numberOfItems: numberOfItems,
//                               price: price)
        self.id = id
        self.name = name
        self.numberOfItems = numberOfItems
        self.price = price
    }
}
