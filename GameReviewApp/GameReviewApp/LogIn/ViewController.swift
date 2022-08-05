//
//  ViewController.swift
//  GameReviewApp
//
//  Created by 池田一篤 on 2022/04/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        // 各TextFieldからメールアドレスとパスワードを取得
        let email = mailAddressTextField.text!
        let password = passWordTextField.text!
        
        // Firebaseに登録済みかアドレスとパスワードの認証チェック
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                
                print("サインインに失敗しました:" ,error!.localizedDescription)
                self.alertMessage(thisTitle: "認証エラー", thisMessage: "入力されたメールアドレスまたはパスワードが正しくありません。")
                return
            }
            
            print("サインインに成功しました", user.email!)
            
            //　登録済みアカウントの場合はレビュートップ画面に遷移して、かつ、ユーザーのユニークIDをshareUserに格納して他の画面でも呼び出せるよにする。
            self.delegate.shareUser = user.uid
            
            self.getCurrentUserInfo()
            self.homeTransition()
        }
    }
    
    // 登録済みのユーザー情報を取得
    private func getCurrentUserInfo() {
        
        Firestore.firestore().collection("users").document(delegate.shareUser).getDocument { (userSnapshot, err) in
            
            if let err = err { print("ユーザーの情報の取得に失敗しました\(err)")
                return
            }
            
            guard let userSnapshot = userSnapshot, let dic = userSnapshot.data() else { return }
            let currentUser = CurrentUser(dic: dic)
            
            self.delegate.userName = currentUser.userName
            
            print("ユーザーネームです", self.delegate.userName)
        }
    }
    
    private func alertMessage(thisTitle:String, thisMessage:String) {
        let alert = UIAlertController(title: thisTitle, message: thisMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true,  completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resistUserButton(_ sender: Any) {
        let userRegistVC = self.storyboard?.instantiateViewController(withIdentifier: "userRegistVC") as! UsereResistViewController
        navigationController?.pushViewController(userRegistVC, animated: true)
    }
    
    // Homeへ画面遷移
    private func homeTransition() {
        let home = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = home.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    //テスト用の画面遷移ボタンを一時的に作成
    @IBAction func testNextButton(_ sender: Any) {
        
        
        // 各TextFieldからメールアドレスとパスワードを取得
        let email = "test007@gmail.com"
        let password = "123456"
        
        // Firebaseに登録済みかアドレスとパスワードの認証チェック
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                
                print("サインインに失敗しました:" ,error!.localizedDescription)
                self.alertMessage(thisTitle: "認証エラー", thisMessage: "入力されたメールアドレスまたはパスワードが正しくありません。")
                return
            }
            
            print("サインインに成功しました", user.email!)
            
            //　登録済みアカウントの場合はレビュートップ画面に遷移して、かつ、ユーザーのユニークIDをshareUserに格納して他の画面でも呼び出せるよにする。
            self.delegate.shareUser = user.uid
            
            self.getCurrentUserInfo()
            self.homeTransition()
        }
    }
    
    // TextField入力中に画面をタップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
}

