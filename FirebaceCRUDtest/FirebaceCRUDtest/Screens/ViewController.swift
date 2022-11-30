//
//  ViewController.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 30.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var field1: UILabel!
    @IBOutlet weak var field2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func zaporPressed(_ sender: Any) {
        ApiManager.shared.getPost(collection: "cars",
                                  docName: "smallCar") { doc in
            guard let doc = doc else { return }
            self.field1.text = doc.field1
            self.field2.text = doc.field2
        }
        ApiManager.shared.getImage(picName: "zapor") { image in
            self.carImageView.image = image
        }
        
        
    }
    
    @IBAction func nivaPressed(_ sender: Any) {
        ApiManager.shared.getPost(collection: "cars",
                                  docName: "mediumCar") { doc in
            guard let doc = doc else { return }
            self.field1.text = doc.field1
            self.field2.text = doc.field2
        }
        ApiManager.shared.getImage(picName: "niva") { image in
            self.carImageView.image = image
        }
            }
    
    @IBAction func volgaPressed(_ sender: Any) {
        ApiManager.shared.getPost(collection: "cars",
                                  docName: "bigCar") { doc in
            guard let doc = doc else { return }
            self.field1.text = doc.field1
            self.field2.text = doc.field2
        }
        ApiManager.shared.getImage(picName: "volga") { image in
            self.carImageView.image = image
        }
    }
    
}

