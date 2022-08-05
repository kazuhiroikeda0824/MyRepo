//
//  HomeViewController.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/04/27.
//

import UIKit

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ログイン後にログイン画面へ戻る遷移は不要のためHideをする
        self.navigationItem.hidesBackButton = true
        
        //iOS15ではUITabBarが透明になってしまうことがあるので、iOS15未満と同じ挙動にする
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.gray
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        // Tabbar押下時に詳細画面とWebView画面を削除
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.shareDetailsGameView.removeFromSuperview()
        delegate.shareWEBView.removeFromSuperview()
        
    }
}
