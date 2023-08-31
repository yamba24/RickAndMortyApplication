//
//  DetailsCharacterView.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import UIKit

class DetailsCharacterView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DetailsCharacterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    private func setupUI() {
        titleLabel.numberOfLines = 0
        dataLabel.numberOfLines = 0
    }
}
