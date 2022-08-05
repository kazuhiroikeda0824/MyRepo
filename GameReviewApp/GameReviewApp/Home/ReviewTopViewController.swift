//
//  ReviewTopViewController.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/04/26.
//

import UIKit

class ReviewTopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ログイン後にログイン画面へ戻る遷移は不要のためHideをする
        self.navigationItem.hidesBackButton = true
        
        //一旦backgroundに色付け
        view.backgroundColor = .red
        
//        tabDidtapButton()
        
    }
    
    //tabBarのボタンと押下時の動作実装
    @objc func tabDidtapButton() {

        let tabBarVC = UITabBarController()
        
        let reviewView = ReviewTopViewController()
        let searchView = SearchViewController()
        let newsView = NewsViewController()
        let prfileView = ProfileViewController()
        
        tabBarVC.setViewControllers([reviewView, searchView, newsView, prfileView], animated: false)
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
        
    }
    
    @IBAction func APITestButton(_ sender: Any) {
        
    }
    
}
