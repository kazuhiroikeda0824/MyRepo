//
//  ItemCaptionView.swift
//  GameReviewApp
//
//  Created by 池田一篤 on 2022/05/31.
//

import UIKit

class ItemCaptionView: UIView {
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let contentView = UIView()
        
        myScrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: myScrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: myScrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: myScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: myScrollView.contentLayoutGuide.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: myScrollView.frameLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: myScrollView.frameLayoutGuide.trailingAnchor),
        ])
        
        let label = UILabel()
        label.text = delegate.shareItemCaption
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
        ])
    }

    @IBAction func backButton(_ sender: Any) {
    
        self.removeFromSuperview()
    }
}
