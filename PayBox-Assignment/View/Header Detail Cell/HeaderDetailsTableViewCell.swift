//
//  HeaderDetailsTableViewCell.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 30/08/2023.
//

import UIKit

struct ArrowImage {
    static let upArrow = "up-arrow"
    static let downArrow = "down-arrow"
}
class HeaderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func applyShimmering() {
        headerLabel.lastLineFillPercent = 100
        headerLabel.linesCornerRadius = 5
        headerLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkGray), animation: nil, transition: .crossDissolve(0.25))
    }
    
    func removeShimmering() {
        headerLabel.stopSkeletonAnimation()
        headerLabel.hideSkeleton()
    }
    
    func setCell(emptyState: Bool = false, collapse: Bool, header: String) {
        if emptyState {
            arrowImage.isHidden = true
        } else {
            arrowImage.isHidden = false
            if collapse {
                arrowImage.image = UIImage(named: ArrowImage.upArrow)
            } else {
                arrowImage.image = UIImage(named: ArrowImage.downArrow)
            }
        }
        headerLabel.text = header
    }
}
