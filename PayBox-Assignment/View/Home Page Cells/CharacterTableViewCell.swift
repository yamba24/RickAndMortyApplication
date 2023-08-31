//
//  CharacterTableViewCell.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import UIKit
import Kingfisher
import SkeletonView

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterStatus: UILabel!
    
    private var nameLabelWidthConstraint: NSLayoutConstraint?
    private var statusLabelWidthConstraint: NSLayoutConstraint?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }

    
    private func setupUI() {
        characterName.numberOfLines = 0
        characterStatus.numberOfLines = 0
        
        characterImage.layer.cornerRadius = 40.0
        characterImage.clipsToBounds = true
        
        backgroundColor = .black
        
        characterName.textColor = .orange
        characterStatus.textColor = .gray


    }
    
    func applySkeletonView() {
        characterName.text = "XXXX"
        characterStatus.text = "XXXX"
        
        nameLabelWidthConstraint = characterName.widthAnchor.constraint(equalToConstant: 150)
        statusLabelWidthConstraint = characterStatus.widthAnchor.constraint(equalToConstant: 100)
        
        nameLabelWidthConstraint?.isActive = true
        statusLabelWidthConstraint?.isActive = true
        
        characterName.linesCornerRadius = 5
        characterName.lastLineFillPercent = 100
        
        characterStatus.linesCornerRadius = 5
        characterStatus.lastLineFillPercent = 100
        
        characterName.numberOfLines = 1
        characterStatus.numberOfLines = 1
        
        
        characterStatus.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkGray), animation: nil, transition: .crossDissolve(0.25))
        
        characterImage.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkGray), animation: nil, transition: .crossDissolve(0.25))
        
        characterName.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkGray), animation: nil, transition: .crossDissolve(0.25))
    }

    
    func removeSkeletonView() {
        characterName.numberOfLines = 0
        characterStatus.numberOfLines = 0
        
        nameLabelWidthConstraint?.isActive = false
        statusLabelWidthConstraint?.isActive = false
        
        characterName.stopSkeletonAnimation()
        characterName.hideSkeleton()
        
        characterStatus.stopSkeletonAnimation()
        characterStatus.hideSkeleton()
        
        characterImage.stopSkeletonAnimation()
        characterImage.hideSkeleton()
    }
    
    func setCell(name: String?, status: String?, url: String?) {
        if let name = name, let status = status, let url = url {
            characterName.text = name
            characterStatus.text = status
            characterImage.kf.setImage(with: URL(string: url))
            
        }
    }
}
