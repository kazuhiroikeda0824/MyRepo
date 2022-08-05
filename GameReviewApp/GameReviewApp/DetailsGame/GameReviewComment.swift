//
//  GameReviewComment.swift
//  GameReviewApp
//
//  Created by 池田一篤 on 2022/06/14.
//

import UIKit
import Firebase
import FirebaseFirestore

class GameReviewComment: UIView, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var commentTable: UITableView!
    
    var userCommentModel = [UserCommentModel]()
    
    override func awakeFromNib() {
        commentTable.dataSource = self
        commentTable.delegate = self
        commentTable.separatorStyle = .none
 
        //xibファイルのセルを表示させる。
        commentTable.register(UINib(nibName: "MyReviewCommentCell", bundle: nil), forCellReuseIdentifier: "MyReviewCommentCell")
        
        commentTable.rowHeight = UITableView.automaticDimension
        
        getCommentList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCommentModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyReviewCommentCell = tableView.dequeueReusableCell(withIdentifier: "MyReviewCommentCell") as! MyReviewCommentCell
        
        cell.myUserName.text = "ニックネーム：" + userCommentModel[indexPath.row].nickName
        cell.myComment.text = userCommentModel[indexPath.row].commentText
        
        let myRating = userCommentModel[indexPath.row].ratingStar
        print(myRating)
        cell.setRating(Rating: myRating)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension //自動設定
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    // 登録済みのコメント情報を取得
    private func getCommentList() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
                
        Firestore.firestore().collection("gamedata").document(delegate.orizinalPrimary).collection("users").getDocuments { commentListSnapshot, err in
            if let err = err { print("コメントの情報の取得に失敗しました\(err)")
                return
            }

            // スナップショットから値を取り出しTableView用の配列へAppend
            for document in commentListSnapshot!.documents {
                let userCommentRow = UserCommentModel()
                userCommentRow.nickName = document.data()["nickName"] as! String
                userCommentRow.commentText = document.data()["commentText"] as! String
                userCommentRow.commentGood = document.data()["commentGood"] as! Int
                
                // FireSotreからRatingが取れない場合は初期値として2.5を設定する
                if let myRating = document.data()["ratingStar"] as? Double {
                    userCommentRow.ratingStar = myRating
                } else {
                    userCommentRow.ratingStar = 2.5
                }
                
                self.userCommentModel.append(userCommentRow)
            }
            
            // tableView更新
            self.commentTable.reloadData()
        }
    }
}
