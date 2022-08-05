////
////  NewsTableViewController.swift
////  GameReviewApp
////
////  Created by yutaro on 2022/06/05.
////

import UIKit
import WebKit
import Alamofire

class NewsTableViewController: UITableViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var newsTableView: UITableView!
    
    var feedItem = [FeedItem]()
    //    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if feedItem.count != 0 {
            return feedItem.count
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // TODO;
        // FeedItemだけでとりあえず以下Cellを作っているが他RSSからテーブルを使い回す場合は
        // そのItemの構成によって配列変数もCellやNumberOfRowsなども切り替える処理を入れる必要がある。
        
        //NewsTableViewCell（xibに紐づいているクラスファイル）でインスタンス化する。
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        cell.newsCellData(newsTextViewData: feedItem[indexPath.row].title, newsDateLabelData: feedItem[indexPath.row].pubDate)
        
        // セルタップ時にハイライトしないようにする。
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 遷移先のクラスをインスタンス化
        let nextStoryboard = UIStoryboard(name: "NewsWebView",bundle: nil)
        guard let vc =  nextStoryboard.instantiateInitialViewController() as? NewsWebView else { return }
        
        // タップしたセルのニュースページURLをfeedItemから抽出し、URL型に変換し、値私のため遷移先の変数に格納。
        let getFeedItem = feedItem[indexPath.row]
        vc.getUrl = URL(string: getFeedItem.link)
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
