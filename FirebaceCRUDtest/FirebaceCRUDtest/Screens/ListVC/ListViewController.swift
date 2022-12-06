//
//  ListViewController.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 04.12.2022.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSourse = [FoodItem](){
        didSet {
            tableView.reloadData()
           // print("datasourse: \(dataSourse.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirestoreManager.shared.getFoodItems { result in
            switch result {
            case .success(let items):
                self.dataSourse = items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
       setupVC()
    }
    
    @IBAction func createnewItemButtonTapped(_ sender: Any) {
        self.createNewFoodItem()
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTBCell.id)
                as? ListTBCell else { return UITableViewCell() }
        cell.setupCell(by: self.dataSourse[indexPath.row])
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let item = dataSourse[indexPath.row]
        self.overrideFoodItem(item) { res in
            switch res {
                
            case .success(let item):
                self.dataSourse[indexPath.row] = item
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let item = dataSourse[indexPath.row]
        if editingStyle == .delete {
            FirestoreManager.shared.deleteFoodItem(by: item.id) { err in
                if let err {
                    let text = err.localizedDescription
                    self.someWrongAlert("Caution", text) {}
                } else {
                    self.dataSourse.remove(at: indexPath.row)
                    
                }
            }
        }
    }
}


private extension ListViewController {
    func setupVC() {
        tableView.register(ListTBCell.nib, forCellReuseIdentifier: ListTBCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func createNewFoodItem() {
        let alert = UIAlertController(title: nil,
                                      message: "Create new food item",
                                      preferredStyle: .alert)
        alert.addTextField { field  in
            field.placeholder = "name"
        }
        alert.addTextField { field  in
            field.placeholder = "number of items"
            field.keyboardType = .numberPad
        }
        alert.addTextField { field  in
            field.placeholder = "price"
            field.keyboardType = .numberPad
        }
        alert.addAction(.init(title: "create", style: .default) {_ in
            let texts = alert.textFields
            guard let name = texts?.first?.text,
                  let numberOfItems = Int(texts?[1].text ?? "1"),
                  let price = Int(texts?.last?.text ?? "10") else {return}
            let item = FoodItem( id: nil,
                                 name: name,
                                 numberOfItems: numberOfItems,
                                 price: price)
            FirestoreManager.shared.createFoodItem(foodItem: item) {  result in
                switch result {
                    
                case .success(_):
                    self.dataSourse.append(item)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        })
        alert.addAction(.init(title: "cancel", style: .destructive))
        present(alert, animated: true)
    }
    
    func overrideFoodItem(_ item: FoodItem, completion: @escaping (Result<FoodItem,Error>) -> () ) {
        var number = item.numberOfItems
        var price = item.price
        
        let alert = UIAlertController(title: "Caution!!!",
                                      message: "do you want to change this position?",
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = String(item.numberOfItems)
            field.keyboardType = .numberPad
        }
        alert.addTextField { field in
            field.placeholder = String(item.price)
            field.keyboardType = .numberPad
        }
        alert.addAction(.init(title: "cancel", style: .default))
        alert.addAction(.init(title: "change", style: .destructive) {_ in
            if let newNum = alert.textFields?.first?.text,
               newNum.isEmpty == false {
                number = Int(newNum) ?? 1
            }
            if let newPrice = alert.textFields?.last?.text,
               newPrice.isEmpty == false {
                price = Int(newPrice) ?? 2
            }
            let new = FoodItem(id: item.id, name: item.name, numberOfItems: number, price: price)
            FirestoreManager.shared.createFoodItem(foodItem: new) { result in
                switch result {
                case .success(let item):
                    completion(.success(item))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        })
        present(alert, animated: true)
    }
}
