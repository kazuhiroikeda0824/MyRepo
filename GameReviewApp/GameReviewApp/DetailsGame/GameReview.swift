//
//  GameReview.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/05/29.
//

import UIKit
import Firebase
import Cosmos

class GameReview: UIView {
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var ratingStar: CosmosView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var myRating: Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingStar.settings.fillMode = .half
        
        // 星の初期値を指定
        ratingStar.rating = 2.5
        
        // DidFinishイベントへファンクションを登録
        ratingStar.didFinishTouchingCosmos = didFinishTouchingCosmos
        
    }
    
    // レーティングを受け取るためのファンクション（レーティングタッチの度に呼ばれる）
    private func didFinishTouchingCosmos(_ rating: Double){
        self.myRating = rating
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.removeFromSuperview()
    }
    
    @IBAction func saveReviewButton(_ sender: Any) {
        
        // テストデバックコード
        // TODO,レートをFireStore反映
        print("レーティングは", myRating)
        
        let detailsorizinalPrimary = delegate.orizinalPrimary
        
        // FireSotreよりDBのインスタンス化
        let docRef = Firestore.firestore().collection("gamedata").document(detailsorizinalPrimary)
        
        // ゲームデータの存在確認
        docRef.getDocument { [self] document, error in
            if let document = document, document.exists {
                
                let userUid = delegate.shareUser
                let userName = delegate.userName
                
                guard let comment = commentTextView.text else { return }
                
                // 登録データセット
                let docData = ["nickName": userName,
                               "commentText": comment,
                               "commentGood": true,
                               "ratingStar": myRating
                ] as [String: Any]
                
                // FireSotre書き込み処理
                docRef.collection("users").document(userUid).setData(docData) { (err) in
                    if let err = err {
                        print("Firestoreへのデータ保存に失敗した。　\(err)")
                        
                        return
                    }
                }
            }
        }
    }
    
    // TextField入力中に画面をタップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endEditing(true)
    }
}
