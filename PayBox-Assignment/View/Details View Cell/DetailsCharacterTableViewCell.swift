//
//  DetailsCharacterTableViewCell.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import UIKit
import Kingfisher

class DetailsCharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        descriptionLabel.font = .boldSystemFont(ofSize: 17.0)
        
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        titleLabel.textColor = .white
    }
    
    func setCell(icon: String, title: String, description: String) {
        iconImage.image = UIImage(named: icon)
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
