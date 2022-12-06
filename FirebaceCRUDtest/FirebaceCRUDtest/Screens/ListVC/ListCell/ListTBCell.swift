//
//  ListTBCell.swift
//  FirebaceCRUDtest
//
//  Created by Fedii Ihor on 04.12.2022.
//

import UIKit

class ListTBCell: UITableViewCell {
    static let id = "ListTBCell"
    static var nib: UINib {
        return UINib(nibName: Self.id, bundle: nil)
    }

    @IBOutlet weak var idTextlabel: UILabel!
    @IBOutlet weak var sumTextLabel: UILabel!
    
    func setupCell(by food: FoodItem) {
        idTextlabel.text = food.name
        sumTextLabel.text = food.sumText
    }
    
}
