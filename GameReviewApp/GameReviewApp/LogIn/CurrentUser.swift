//
//  CurrentUser.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/05/29.
//

import Foundation

class CurrentUser {
    
    let email: String
    let userName: String
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.userName = dic["name"] as? String ?? ""
    }
}
