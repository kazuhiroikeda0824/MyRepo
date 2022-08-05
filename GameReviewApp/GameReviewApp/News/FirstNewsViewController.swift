//
//  FirstNewsViewController.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/06/01.
//

import UIKit

class FirstNewsViewController: UIViewController {
    
    var parser = XMLParser()
    var feedItem = [FeedItem]()
    var currentElementName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getXMLData()
        
        parser.delegate = self
        parser.parse()
        
        let firstTableView = NewsTableViewController()
        
        firstTableView.feedItem = feedItem
        
        // View に追加
        self.addChild(firstTableView)
        self.view.addSubview(firstTableView.view)
        firstTableView.didMove(toParent: self)
        firstTableView.view.translatesAutoresizingMaskIntoConstraints = false
        
        // VIewの大きさをsafeAreaに合わせる。
        NSLayoutConstraint.activate([
            firstTableView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            firstTableView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstTableView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            firstTableView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func getXMLData(){
        //XML解析を行う
        let urlString = "https://news.denfaminicogamer.jp/feed"
        
        if let url = URL(string: urlString){
            parser = XMLParser(contentsOf: url)!
        }
    }
}
extension FirstNewsViewController:XMLParserDelegate{
    
    //①要素解析の開始（要素の読み込み時）
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        //elementName = response
        if elementName == "item" {
            
            self.feedItem.append(FeedItem())
        } else {
            
            currentElementName = elementName
        }
    }
    
    //②要素内の値の取得（要素が見つかった時の挙動）
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.feedItem.count > 0 {
            //meigenとautherを処理していく
            let lastItem = self.feedItem[self.feedItem.count - 1]
            
            switch self.currentElementName {

            case "title":
                lastItem.title = string

            case "link":
                lastItem.link = string
                
            case "pubDate":
                lastItem.pubDate = string
                            
            default:

                break
            }
        }
    }
    
    //③要素の終了時（要素が見つかった時の挙動が終わった時）
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        currentElementName = nil
    }
    
    //④要素の読み込みが終わった時（ここでTableViewの更新をしたりする）
    func parserDidEndDocument(_ parser: XMLParser!) {
        
    }
}

