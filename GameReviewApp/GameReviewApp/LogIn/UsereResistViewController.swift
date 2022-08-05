//
//  UsereResistViewController.swift
//  GameReviewApp
//
//  Created by 池田一篤 on 2022/04/21.
//

import UIKit
import Firebase

class UsereResistViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextFieldConfirm: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var passWordTextFieldConfirm: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    var DBPassword:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resistButton(_ sender: Any) {
        handleAuthToFirebase()
    }
    
    private func handleAuthToFirebase () {
        
        
        //-------------------------------------------
        // メールアドレスとパスワード、ニックネームのバリデーション
        //-------------------------------------------

        // guard let やif letでできるかもだがブランク判定のやり方が不明。後で見直したい
        let email = emailTextField.text!
        if email.isEmpty {
            alertMessage(thisTitle: "メールアドレスが空白です", thisMessage: "メールアドレスを入力してください")
            return
        }

        if email != emailTextFieldConfirm.text! {
            alertMessage(thisTitle: "再入力されたメールアドレスが異なります", thisMessage: "確認用メールアドレスを一致させて下さい")
            return
        }

        let passWord = passWordTextField.text!
        if passWord.isEmpty {
            alertMessage(thisTitle: "パスワードが空白です", thisMessage: "パスワードを入力してください")
            return
        }
        
        if email != emailTextFieldConfirm.text! {
            alertMessage(thisTitle: "再入力されたメールアドレスが異なります", thisMessage: "確認用メールアドレスを一致させて下さい")
            return
        }

        // 最小パスワード数が6文字のため。FireSotreで設定できるのかも
        if passWord.count <= 5 {
            alertMessage(thisTitle: "パスワードが短すぎます", thisMessage: "パスワードは６文字以上で入力してください")
            return
        }

        if passWord != passWordTextFieldConfirm.text! {
            alertMessage(thisTitle: "再入力されたパスワードが異なります", thisMessage: "確認用パスワードを一致させて下さい")
            return
        }
        
        // guard let やif letでできるかもだがブランク判定のやり方が不明。後で見直したい
        let name = nickNameTextField.text!
        if name.isEmpty {
            alertMessage(thisTitle: "ニックネームが空白です", thisMessage: "ニックネームを入力してください")
            return
        }
        
        //-------------------------------------------
        // 入力メールアドレスの存在チェック
        //-------------------------------------------

        // FireSotreより登録データの取得処理
        let db = Firestore.firestore()
        
        // usersテーブルのemailのフィールドが画面入力のEmailと等しい場合、パスワードを取り出す
        db.collection("users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("クエリ取得エラー: \(err)")
            } else {
                
                // emailがDBに登録されてない(新規登録して問題なし)
                if querySnapshot!.documents.isEmpty {
                    
                    // FireSotreへの接続とメールパスワード、ニックネームの保存処理
                    Auth.auth().createUser(withEmail: email, password: passWord) { res, err in
                        
                        if let err =  err {
                            print("認証情報の保存に失敗した。　\(err)")
                            return
                        }
                        
                        guard let uid = Auth.auth().currentUser?.uid  else {return}
                        
                        // 登録データセット
                        let docData = ["email": email, "password": passWord ,"name": name, "createAt": Timestamp()] as [String : Any]

                        // FireSotre書き込み処理
                        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                            if let err = err {
                                print("Firestoreへの保存に失敗した。　\(err)")
                                return
                            }

                            print("FireStoreへの保存に成功しました")
                            
                        }
                        
                    }
                    
                // emailと一致するスナップショットデータが取れた場合(emailが既存)
                } else {
                                        
                    // OK、キャンセルボタン
                    let alert = UIAlertController(title: "入力されたメールアドレスは登録済みです。", message: "再設定パスワードを登録メールアドレスへ送信しますか？", preferredStyle: .alert)
                    
                    // 登録メールアドレスへパスワードを送信
                    let ok = UIAlertAction(title: "OK", style: .default) { [self] (action) in
                        
                        // DB登録のパスワードを取得
                        for document in querySnapshot!.documents {
                            
                            // DB格納のパスワード
                            DBPassword = document.data()["password"] as! String
                            
                            print(DBPassword)
                        }

                        // TODO MessageUIを使いパスワードの再設定メールの送信処理
                        // シミュレーターではメール送信できないため、挙動確認は実機デバックが必要
                        print("メールアドレスへ送信")
                        
                        self.dismiss(animated: true,  completion: nil)
                    }
                    
                    // キャンセル処理の場合何もせずReturn
                    let cancel = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                        self.dismiss(animated: true,  completion: nil)
                        return
                    }
                    
                    alert.addAction(ok)
                    alert.addAction(cancel)

                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
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

}
