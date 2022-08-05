//
//  UserCommentModel.swift
//  GameReviewApp
//
//  Created by 池田一篤 on 2022/06/19.
//

import Foundation
class UserCommentModel {
    
    var nickName: String
    var commentText: String
    var commentGood: Int
    var ratingStar: Double
    
    init(){
        self.nickName = ""
        self.commentText = ""
        self.commentGood = 0
        self.ratingStar = 0.0
    }
    
}
