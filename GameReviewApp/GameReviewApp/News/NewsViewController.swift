//
//  NewsViewController.swift
//  GameReviewApp
//
//  Created by yutaro on 2022/04/26.
//

import UIKit
import Parchment

class NewsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePagingView()
    }
    
    // 横スクロールでViewを切り替える（PagingView）の実装
    private func makePagingView() {
        
        //　横スクロールで切り替えるViewControllerクラスをインスタンス化し、pagingViewの要素として格納。
        let firstViewController = FirstNewsViewController()
        firstViewController.title = "電ファミニコゲーマー"
        
        let secondViewController = SecondNewsViewController()
        secondViewController.title = "NEWS2"
        
        let thirdNewsViewController = ThirdNewsViewController()
        thirdNewsViewController.title = "NEWS3"
        
        let pagingView = PagingViewController(viewControllers: [
            firstViewController,
            secondViewController,
            thirdNewsViewController
        ])
        
        // View に追加
        self.addChild(pagingView)
        self.view.addSubview(pagingView.view)
        pagingView.didMove(toParent: self)
        pagingView.view.translatesAutoresizingMaskIntoConstraints = false
        
        // VIewの大きさをsafeAreaに合わせる。
        NSLayoutConstraint.activate([
            pagingView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pagingView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pagingView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pagingView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
