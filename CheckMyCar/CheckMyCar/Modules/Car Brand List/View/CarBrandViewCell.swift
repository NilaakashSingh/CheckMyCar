//
//  CarBrandViewCell.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 22/12/21.
//

import UIKit

class CarBrandViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var manufacturerNameLabel: UILabel!
    
    // MARK: - Configure Method
    func configure(manufacturerName: String, oddCell: Bool) {
        manufacturerNameLabel.text = manufacturerName
        backgroundColor = oddCell ? UIColor.lightText : .clear
    }
}
