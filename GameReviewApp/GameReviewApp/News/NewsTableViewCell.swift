//
//  NewsTableViewCell.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/06/05.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var newsDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // newsTextViewをユーザーが編集できなくし、スクロールできなくし、didSelectRowAtが有効になるようにした。
        self.newsTextView.isEditable = false
        self.newsTextView.isUserInteractionEnabled = false
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func newsCellData(newsTextViewData: String, newsDateLabelData: String) {
        
        newsTextView.text = newsTextViewData
        newsDateLabel.text = newsDateLabelData
        
    }
}
