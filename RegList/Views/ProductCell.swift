//
//  ProductCell.swift
//  RegList
//
//  Created by Тадевос Курдоглян on 14.08.2025.
//

import UIKit

final class ProductCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func configure(title: String, price: String) {
        titleLabel.text = title
        priceLabel.text = price
    }
}
