//
//  SearchTableViewCell.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/05/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var searchHardLabel: UILabel!
    @IBOutlet weak var searchDevelopLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func searchBinData(imagey: UIImage,  titley: String, hardy: String, developy: String) {
        
        searchImageView.image = imagey
        searchTitleLabel.text = titley
        searchHardLabel.text = hardy
        searchDevelopLabel.text = developy
        
    }
    
}
