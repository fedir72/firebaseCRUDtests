//
//  ViewController.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 30.11.2022.
//

import UIKit


class ViewController: UIViewController {
    
    var images: [UIImage] = [UIImage(named: "girl01")!,
                             UIImage(named: "girl02")!,
                             UIImage(named: "girl03")!]
 
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var field1: UILabel!
    @IBOutlet weak var field2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if AuthService.shared.currentUser != nil {
//            print("done")
//        } else {
//            showSighVC()
//            print("you need register")
//        }
    }
    
    
    @IBAction func addNewImageButtonPressed(_ sender: UIButton) {
        self.searchPhoto(sender)
    }
    
    
    @IBAction func showRegisterFormTapped(_ sender: Any) {
        showSighVC()
    }
    
    @IBAction func deleteuserTapped(_ sender: Any) {
        AuthService.shared.deleteCurrentUser { error in
            var alertText = ""
            if let error {
                alertText = error.localizedDescription
            } else {
                alertText = "user is succesfuly deleted"
            }
            self.someWrongAlert("atension",
                                alertText,
                                completion: {})
        }
    }
    

    

    @IBAction func zaporPressed(_ sender: Any) {
        FirestoreManager.shared.getPost(collection: "cars",
                                  docName: "smallCar") { doc in
            guard let doc = doc else { return }
            self.field1.text = doc.field1
            self.field2.text = doc.field2
        }
        StorageManager.shared.getImage(picName: "zapor") { image in
            self.carImageView.image = image
        }
        
        
    }
    
    @IBAction func nivaPressed(_ sender: Any) {
        FirestoreManager.shared.getPost(collection: "cars",
                                  docName: "mediumCar") { doc in
            guard let doc = doc else { return }
            self.field1.text = doc.field1
            self.field2.text = doc.field2
        }
        StorageManager.shared.getImage(picName: "niva") { image in
            self.carImageView.image = image
        }
            }
    
    @IBAction func volgaPressed(_ sender: Any) {
        FirestoreManager.shared.getPost(collection: "cars",
                                  docName: "bigCar") { doc in
            guard let doc = doc else { return }
            self.field1.text = doc.field1
            self.field2.text = doc.field2
        }
        StorageManager.shared.getImage(picName: "volga") { image in
            self.carImageView.image = image
        }
    }
    
}

private extension ViewController {
    func showSighVC() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AuthViewController"),
            vc as? AuthViewController != nil else { return }
            navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchPhoto(_ sender: UIButton) {
        let act = UIImagePickerController()
        act.delegate = self
        act.sourceType = .photoLibrary
        present(act, animated: true)
        
        
    }
}
extension ViewController: UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion:  nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage else {return}
        StorageManager.shared.uploadImage(image: image) { res in
            switch res {
                
            case .success(let url):
                print(url)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        print("image",image.description)
    }
}
