//
//  SearchViewController.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/04/26.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    // APIのページとページカウントを取得
    var page:Int = 0
    var pageCount:Int = 0
    var hits:Int = 0
    
    // APIロードフラグ
    var isLoading = false
    
    let permitHardWareArray = ["Nintendo Switch Lite","Nintendo Switch","PS5","PS4","PS3","PS2","Nintendo 3DS","GAMEBOY ADVANCE","VirtualBoy","GameBoy","Xbox Series X/XboxOne","NINTENDO 64","Xbox Series","Xbox Series X","XboxOne","FC"]
    
    // ページング用の再検索用にURLをグローバル変数化
    var url:String = ""
    
    // １ゲーム文のレコードデータを作成し配列化
    var gameDataRow:Dictionary<String,String> = [:]
    var gameDataArray: [[String: Any]] = [] {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //xibファイルのセルを表示させる。
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        // TableViewの定型文
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
    }
    
    private func getGameInfomation(searchWord:String) {
        
        // 入力文字列をUTF8へデコードしてStringへ戻す
        let title = "&title=" + String(searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let myId = "&applicationId=APIキーの為秘匿"
        let baseurl = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&booksGenreId=006&"
        
        // URL整形
        url = baseurl + myId + title
        
        AF.request(url).responseJSON { (respons) in
            switch respons.result {
                
            case .success:
                print("API通信成功")
                do {
                    // JSONパース
                    let json:JSON = JSON(respons.data as Any)
                    
                    // APIのページとページカウントを取得
                    self.page = json["page"].int!
                    self.pageCount = json["pageCount"].int!
                    self.hits = json["hits"].int!
                    
                    // ページのHitsだけループ
                    for index in 0 ..< self.hits {
                        // .string!で強制的にキャストしてる？よいやり方ではないかも
                        let hardware:String = json["Items"][index]["Item"]["hardware"].string!
                        
                        // 指定ハードウェア以外のJsonデータは配列に入れない為にBreakする
                        var isPermit = false
                        for permitHardWare in self.permitHardWareArray {
                            if (hardware == permitHardWare) {
                                isPermit = true
                            }
                        }
                        if (!isPermit) {
                            break
                        }
                        
                        let itemCaption:String = json["Items"][index]["Item"]["itemCaption"].string!
                        let mediumImageUrl:String = json["Items"][index]["Item"]["mediumImageUrl"].string!
                        let reviewAverage:String = json["Items"][index]["Item"]["reviewAverage"].string!
                        let title:String = json["Items"][index]["Item"]["title"].string!
                        let titleKana:String = json["Items"][index]["Item"]["titleKana"].string!
                        let label:String = json["Items"][index]["Item"]["label"].string!
                        let booksGenreId: String = json["Items"][index]["Item"]["booksGenreId"].string!
                        
                        self.gameDataRow = ["hardware":hardware,"itemCaption":itemCaption,"mediumImageUrl":mediumImageUrl,"reviewAverage":reviewAverage,"title":title,"titleKana":titleKana,"label":label,"booksGenreId":booksGenreId]
                        self.gameDataArray.append(self.gameDataRow)
                    }
                    self.searchTableView.reloadData()
                } catch {
                    print("失敗しました")
                }
            case.failure(let error):
                print("error", error)
            }
        }
    }
    
    private func getLoadingGameInfomation (thisPage:Int, thisPageCount:Int) {
        
        // PageのパラメーターによってAPIのURLを可変にする
        let strPage = String(thisPage)
        AF.request(url + "&page=" + strPage).responseJSON { (respons) in
            switch respons.result {
                
            case .success:
                print("API通信成功")
                print(self.url + "&page=" + strPage)
                do {
                    // JSONパース
                    let json:JSON = JSON(respons.data as Any)
                    
                    // APIのページとページカウントを取得
                    self.hits = json["hits"].int!
                    
                    // ページのHitsだけループ
                    for index in 0 ..< self.hits {
                        // .string!で強制的にキャストしてる？よいやり方ではないかも
                        let hardware:String = json["Items"][index]["Item"]["hardware"].string!
                        
                        // 指定ハードウェア以外のJsonデータは配列に入れない為にBreakする
                        var isPermit = false
                        for permitHardWare in self.permitHardWareArray {
                            if (hardware == permitHardWare) {
                                isPermit = true
                            }
                        }
                        
                        if (!isPermit) {
                            break
                        }
                        
                        let itemCaption:String = json["Items"][index]["Item"]["itemCaption"].string!
                        let mediumImageUrl:String = json["Items"][index]["Item"]["mediumImageUrl"].string!
                        let reviewAverage:String = json["Items"][index]["Item"]["reviewAverage"].string!
                        let title:String = json["Items"][index]["Item"]["title"].string!
                        let titleKana:String = json["Items"][index]["Item"]["titleKana"].string!
                        let label:String = json["Items"][index]["Item"]["label"].string!
                        let booksGenreId: String = json["Items"][index]["Item"]["booksGenreId"].string!
                        
                        self.gameDataRow = ["hardware":hardware,"itemCaption":itemCaption,"mediumImageUrl":mediumImageUrl,"reviewAverage":reviewAverage,"title":title,"titleKana":titleKana,"label":label,"booksGenreId":booksGenreId]
                        self.gameDataArray.append(self.gameDataRow)
                        print(hardware)
                    }
                    self.searchTableView.reloadData()
                    self.isLoading = false
                } catch {
                    print("失敗しました")
                }
            case.failure(let error):
                print("error", error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        let tableViewArray = gameDataArray[indexPath.row]
        
        //Cellに表示させるのに必要な値を変数に代入（imageのみ値なしで宣言）
        let image: UIImage
        let title = tableViewArray["title"] as! String
        let hard = tableViewArray["hardware"] as! String
        let develop = tableViewArray["label"] as! String
        
        //サムネイル用の画像を取得
        let imageStr = tableViewArray["mediumImageUrl"] as! String
        let url = URL(string: imageStr)
        
        do {
            let data = try! Data(contentsOf: url!)
            image = UIImage(data: data)!
        } catch {
            print(error)
        }
        //xibファイルへ値を渡す
        cell.searchBinData(imagey: image, titley: title, hardy: hard, developy: develop)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // AppDelegateにてクラスを跨いでゲームタイトルを値渡し
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.shareTitle = gameDataArray[indexPath.row]["title"] as! String
        delegate.shareItemCaption = gameDataArray[indexPath.row]["itemCaption"] as! String
        delegate.shareBooksGenreId = gameDataArray[indexPath.row]["booksGenreId"] as! String
        delegate.shareMediumImageUrl = gameDataArray[indexPath.row]["mediumImageUrl"] as! String
        
        delegate.shareDetailsGameView = Bundle.main.loadNibNamed("DetailsGameView", owner: self, options: nil)?.first as! DetailsGameView
        self.view.addSubview(delegate.shareDetailsGameView)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // TableViewの一番下まで行った場合のみに追加API読み込みを指せるIF判定
        if (self.searchTableView.contentOffset.y + self.searchTableView.frame.size.height > self.searchTableView.contentSize.height && self.searchTableView.isDragging && !isLoading && !(self.page >= self.pageCount)) {
            
            // ロードフラグとページ送りを更新
            isLoading = true
            self.page += 1
            
            // 追加でのAPI読み込みFunc
            getLoadingGameInfomation(thisPage: self.page, thisPageCount: self.pageCount)
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        let seachWord = searchTextField.text!
        
        // ブランク処理
        if (seachWord.isEmpty) {
            return
        }
        
        // 再検索の前に配列削除
        gameDataArray.removeAll()
        
        // APIにより表示アイテムを取得
        getGameInfomation(searchWord: seachWord)
        searchTableView.reloadData()
    }
    
    // 「検索」ボタンタップでTextField入力中のキーボードを閉じる
    @IBAction func closeTextField(_ sender: Any) {
        
        view.endEditing(true)
    }
}


