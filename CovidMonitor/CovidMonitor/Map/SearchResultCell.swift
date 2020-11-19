//
//  SearchResultCell.swift
//  PullUpControllerDemo
//
//  Created by Harshit on 12/11/2020.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet weak var lblCaseCount: UILabel!
    func configure(location: String, count: String) {
        titleLabel.text = location
        lblCaseCount.text = count
        lblCaseCount.layer.masksToBounds = true
        lblCaseCount.layer.cornerRadius = 10.0
    }
}
