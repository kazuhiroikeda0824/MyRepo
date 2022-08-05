//
//  DetailsGameView.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/05/11.
//

import UIKit
import Firebase
import Cosmos

class DetailsGameView: UIView {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var itemCaptionLabeel: UILabel!
    @IBOutlet weak var myViewInScroll: UIView!
    @IBOutlet weak var averageCosmosView: CosmosView!
    @IBOutlet weak var ratingNumberLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var reviewComment: UIButton!
    @IBOutlet weak var gameInfoLabel: UILabel!
    @IBOutlet weak var gameDetailInfoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var booksGenreId = ""
        var title = ""
        
        var userRatingStar = [Double]()
        var averageStarNumber: Double = 0.0

        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        // 見た目のデザイン
        reviewButton.layer.cornerRadius = 15
        reviewComment.layer.cornerRadius = 15
        itemCaptionLabeel.layer.cornerRadius = 15
        itemCaptionLabeel.clipsToBounds = true
        gameInfoLabel.layer.cornerRadius = 10
        gameInfoLabel.clipsToBounds = true
        gameDetailInfoButton.layer.cornerRadius = 15
        
        // 星の数をUIから変更できないようにする。
        averageCosmosView.settings.updateOnTouch = false
 
        // 星の数を細かく表示できるようにする。
        averageCosmosView.settings.fillMode = .precise
        
        // 星初期値
        averageCosmosView.rating = 0.0
        
        //ゲーム画像を取得して貼り付け
        let image: UIImage
        let imageStr = delegate.shareMediumImageUrl
        let url = URL(string: imageStr)
        
        do {
            let data = try! Data(contentsOf: url!)
            image = UIImage(data: data)!
        } catch {
            print(error)
        }
        gameImageView.image = image
        
        // ゲーム説明
        itemCaptionLabeel.numberOfLines = 0
        itemCaptionLabeel.text = delegate.shareItemCaption
        
        booksGenreId = delegate.shareBooksGenreId
        title = delegate.shareTitle
        delegate.orizinalPrimary = title + booksGenreId
        
        // FireSotreよりDBのインスタンス化
        let docRef = Firestore.firestore().collection("gamedata").document(delegate.orizinalPrimary)
        
        // ゲームデータの存在確認
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                
                //
                // ゲームデータが存在する場合以下のインクリメント処理
                //
                
                // PageViewCountのインクリメント(ゲームタイトル毎の詳細ページを見られた回数)
                docRef.updateData(["pageViewCount" : FieldValue.increment(Int64(1))])
                
                // ユーザーレビューのRatingStarを取得
                docRef.collection("users").getDocuments() { (querySnaphot, err) in
                    if  let err = err {
                        print("MyERR", err)
                    } else {
                        
                        for document in querySnaphot!.documents {
                            
                            if document.data()["ratingStar"] != nil {
                                userRatingStar.append(document.data()["ratingStar"] as! Double)
                            }
                        }
                        
                        // 配列に入っている総レビュー数から平均を算出
                        if userRatingStar.count != 0 {
                            for ratingStar in userRatingStar {
                                averageStarNumber += ratingStar
                            }
                            averageStarNumber = averageStarNumber / Double(userRatingStar.count)
                            // 星の数を指定。
                            print(averageStarNumber)
                            self.averageCosmosView.rating = averageStarNumber
                            self.ratingNumberLabel.text = ("\(averageStarNumber) /5")
                        }
                    }
                }
            } else {
                
                //
                // ゲームデータが存在しない場合以下のPageViewカウント登録登録処理
                //
                
                // pageViewCountの初期設定
                let pageViewCountData = ["pageViewCount":1]
                
                // FireSotre書き込み処理
                docRef.setData(pageViewCountData) { (err) in
                    if let err = err {
                        print("FirestoreへのPageViewCountの保存に失敗した。　\(err)")
                        return
                    }
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.removeFromSuperview()
    }
            
    // レビュー入力画面へ遷移（テスト用）
    @IBAction func goReviewButton(_ sender: Any) {
        
        let goGameReview = Bundle.main.loadNibNamed("GameReview", owner: self, options: nil)?.first as! GameReview
        self.addSubview(goGameReview)
    }
    
    @IBAction func itemCaptionButton(_ sender: Any) {
        
        let goItemCaptionView = Bundle.main.loadNibNamed("ItemCaptionView", owner: self, options: nil)?.first as! ItemCaptionView
        self.addSubview(goItemCaptionView)

    }
    
    @IBAction func reviewCommentButton(_ sender: Any) {
        
        let gameReviewComment = Bundle.main.loadNibNamed("GameReviewComment", owner: self, options: nil)?.first as! GameReviewComment
        self.addSubview(gameReviewComment)
    }
}
