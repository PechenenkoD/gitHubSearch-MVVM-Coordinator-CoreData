//
//  DetailRepositoryCell.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 05.07.2022.
//

import UIKit

protocol DetailRepositoryCellProtocol {
    func configureCell(_ text: String)
}

final class DetailRepositoryCell: UITableViewCell, DetailRepositoryCellProtocol {

    @IBOutlet weak var loginLabel: UILabel!
    
    func configureCell(_ text: String) {
        self.loginLabel.text = text
    }
    
}
