//
//  NewsWebView.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/07/16.
//

import UIKit
import WebKit

class NewsWebView: UIViewController {

    @IBOutlet weak var newsWebView: WKWebView!
    
    var getUrl: URL! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // NewsTableViewControllerから受けとったURLページを表示させる。
        let myRequest = URLRequest(url: getUrl!)
        newsWebView.load(myRequest)
    }
}
