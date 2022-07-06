//
//  DetailRepositoryCell.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 05.07.2022.
//

import UIKit

final class DetailRepositoryCell: UITableViewCell {

    @IBOutlet weak var loginLabel: UILabel!
    
    func configureCell(_ text: String) {
        self.loginLabel.text = text
    }
    
}
