//
//  MyReviewCommentCell.swift
//  GameReviewApp
//
//  Created by 池田一篤 on 2022/07/05.
//

import UIKit
import Cosmos

class MyReviewCommentCell: UITableViewCell {
    
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var myUserName: UILabel!
    @IBOutlet weak var myRating: CosmosView!
    @IBOutlet weak var myComment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myRating.settings.fillMode = .half
        
        mainBackgroundView.layer.cornerRadius = 8
        mainBackgroundView.layer.masksToBounds = true
//        mainBackgroundView.layer.borderWidth = 1.0
//        mainBackgroundView.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setRating(Rating: Double){
        myRating.rating = Rating
    }
}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
