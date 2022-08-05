//
//  ReviewTopViewController.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/04/26.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReviewTopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var ps5RecommendCollectionView: UICollectionView!
    @IBOutlet weak var switchRecommendCollectionView: UICollectionView!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    
    // APIのページとページカウントを取得
    var page:Int = 0
    var pageCount:Int = 0
    var hits:Int = 0
    
    // １ゲーム文のレコードデータを作成し配列化
    var gameDataRow:Dictionary<String,String> = [:]
    var gameDataArray = [Dictionary<String,String>]()
    var gameDataArrayPS5 = [Dictionary<String,String>]()
    var gameDataArraySwitch = [Dictionary<String,String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGameInfomation(url: "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=PS4&booksGenreId=006&reviewAverage=standard&applicationId=APIキーの為秘匿",gameHard: "PS4")
        getGameInfomation(url: "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=PS5&booksGenreId=006&reviewAverage=standard&applicationId=APIキーの為秘匿",gameHard: "PS5")
        getGameInfomation(url: "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=Nintendo%20Switch&booksGenreId=006&reviewAverage=standard&applicationId=APIキーの為秘匿",gameHard: "Switch")

        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        ps5RecommendCollectionView.delegate = self
        ps5RecommendCollectionView.dataSource = self
        switchRecommendCollectionView.delegate = self
        switchRecommendCollectionView.dataSource = self
        
        let nib = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)
        self.recommendCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        self.ps5RecommendCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        self.switchRecommendCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        //CollectionViewを横スクロールにする
        let myLayout = UICollectionViewFlowLayout()
        myLayout.scrollDirection = .horizontal
        recommendCollectionView.collectionViewLayout = myLayout
        
        let myLayout2 = UICollectionViewFlowLayout()
        myLayout2.scrollDirection = .horizontal
        ps5RecommendCollectionView.collectionViewLayout = myLayout2

        let myLayout3 = UICollectionViewFlowLayout()
        myLayout3.scrollDirection = .horizontal
        switchRecommendCollectionView.collectionViewLayout = myLayout3
        
        //CollectionViewのスクロールバーを非表示
        recommendCollectionView.showsHorizontalScrollIndicator = false;
        ps5RecommendCollectionView.showsHorizontalScrollIndicator = false;
        switchRecommendCollectionView.showsHorizontalScrollIndicator = false;

    }
    
    private func getGameInfomation(url:String, gameHard:String) {
        // API実装部分
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (respons) in
            switch respons.result{
            case .success:
                // JSONパース
                let json:JSON = JSON(respons.data as Any)
                
                // APIのページとページカウントを取得
                self.page = json["page"].int!
                self.pageCount = json["pageCount"].int!
                self.hits = json["hits"].int!
                
                // ページの数だけループ
                for i in 0 ..< self.page {
                    // ページのHits（Items数）だけループ
                    for index in 0 ..< self.hits {
                        // .string!で強制的にキャストしてる？よいやり方ではないかも
                        let hardware: String = json["Items"][index]["Item"]["hardware"].string!
                        let itemCaption: String = json["Items"][index]["Item"]["itemCaption"].string!
                        let mediumImageUrl: String = json["Items"][index]["Item"]["mediumImageUrl"].string!
                        let reviewAverage: String = json["Items"][index]["Item"]["reviewAverage"].string!
                        let title: String = json["Items"][index]["Item"]["title"].string!
                        let titleKana: String = json["Items"][index]["Item"]["titleKana"].string!
                        let booksGenreId: String = json["Items"][index]["Item"]["booksGenreId"].string!
                        let largeImageUrl: String = json["Items"][index]["Item"]["largeImageUrl"].string!

                        // 以下self.部分がメモリーリークしそうだが、まだ調べてない
                        self.gameDataRow = ["hardware": hardware, "itemCaption": itemCaption, "mediumImageUrl": mediumImageUrl, "reviewAverage": reviewAverage, "title": title, "titleKana": titleKana,"booksGenreId": booksGenreId, "largeImageUrl":largeImageUrl]
                        
                        if gameHard == "PS4" {
                            self.gameDataArray.append(self.gameDataRow)
                        } else if gameHard == "PS5" {
                            self.gameDataArrayPS5.append(self.gameDataRow)
                        } else if gameHard == "Switch" {
                            self.gameDataArraySwitch.append(self.gameDataRow)
                        }
                        
                    }
                }
                
                self.recommendCollectionView.reloadData()
                self.ps5RecommendCollectionView.reloadData()
                self.switchRecommendCollectionView.reloadData()

                break
                
            case .failure(let error):
                print("API通信失敗")
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == recommendCollectionView {
            return self.gameDataArray.count
        } else if collectionView == ps5RecommendCollectionView {
            return self.gameDataArrayPS5.count
        } else if collectionView == switchRecommendCollectionView {
            return self.gameDataArraySwitch.count
        } else {
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecommendCollectionViewCell
        var tableViewArray:Dictionary<String,String> = [:]
        
        if collectionView == recommendCollectionView {
            tableViewArray = gameDataArray[indexPath.row]
        } else if collectionView == ps5RecommendCollectionView {
            tableViewArray = gameDataArrayPS5[indexPath.row]
        } else if collectionView == switchRecommendCollectionView {
            tableViewArray = gameDataArraySwitch[indexPath.row]
        } else {
            return cell
        }
        
        //サムネイル用の画像を取得
        let image: UIImage
        let imageStr = tableViewArray["mediumImageUrl"]!
        let url = URL(string: imageStr)
        
        do {
            
            let data = try! Data(contentsOf: url!)
            image = UIImage(data: data)!
            
        } catch {
            
            print(error)
            
        }
        
        cell.recommendCellImageView.image = image
        
        //ゲームタイトルを取得
        let titleValue = tableViewArray["title"]
        cell.titleLabel.text = titleValue
        
        //セルの角を丸くする
        cell.layer.cornerRadius = 18
        
        //コレクションビューのセル（ゲームサムネイル）に影を入れる
                cell.layer.masksToBounds = false
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOpacity = 1
                cell.layer.shadowRadius = 9
                cell.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Cellのサイズと余白を設定
        let heightSize = collectionView.frame.height
        let widthSize = collectionView.frame.width
        
        return CGSize(width: widthSize/4, height: heightSize)
        
    }
    
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // AppDelegateにてクラスを跨いでゲームタイトルを値渡し
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        // コレクションビューにより分岐
        if collectionView == recommendCollectionView {
            delegate.shareTitle = gameDataArray[indexPath.row]["title"]!
            delegate.shareItemCaption = gameDataArray[indexPath.row]["itemCaption"]!
            delegate.shareBooksGenreId = gameDataArray[indexPath.row]["booksGenreId"]!
            delegate.shareMediumImageUrl = gameDataArray[indexPath.row]["mediumImageUrl"]!
        } else if collectionView == ps5RecommendCollectionView {
            delegate.shareTitle = gameDataArrayPS5[indexPath.row]["title"]!
            delegate.shareItemCaption = gameDataArrayPS5[indexPath.row]["itemCaption"]!
            delegate.shareBooksGenreId = gameDataArrayPS5[indexPath.row]["booksGenreId"]!
            delegate.shareMediumImageUrl = gameDataArrayPS5[indexPath.row]["mediumImageUrl"]!
        } else if collectionView == switchRecommendCollectionView {
            delegate.shareTitle = gameDataArraySwitch[indexPath.row]["title"]!
            delegate.shareItemCaption = gameDataArraySwitch[indexPath.row]["itemCaption"]!
            delegate.shareBooksGenreId = gameDataArraySwitch[indexPath.row]["booksGenreId"]!
            delegate.shareMediumImageUrl = gameDataArraySwitch[indexPath.row]["mediumImageUrl"]!
        } else {
            return
        }

        delegate.shareDetailsGameView = Bundle.main.loadNibNamed("DetailsGameView", owner: self, options: nil)?.first as! DetailsGameView
        self.view.addSubview(delegate.shareDetailsGameView)
    }
}
