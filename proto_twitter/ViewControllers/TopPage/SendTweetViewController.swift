//
//  SendTweetViewController.swift
//  proto_twitter
//
//  Created by fukuda_kosuke on 2018/12/10.
//  Copyright © 2018 福田光祐. All rights reserved.
//

import UIKit

class SendTweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var tweetPhotoimageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetPhotoimageView.contentMode = UIViewContentMode.scaleAspectFill
        // 入力がなければreturnキーを無効にする
        tweetTextView.enablesReturnKeyAutomatically = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ナビゲーションバーの閉じるボタンを作成
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title : "閉じる",
                                                                style : UIBarButtonItemStyle.plain,
                                                                target: self,
                                                                action: #selector(SendTweetViewController.close))
        // ナビゲーションバー右のボタンを設定
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title : "投稿",
                                                                 style : UIBarButtonItemStyle.plain,
                                                                 target: self,
                                                                 action:  #selector(SendTweetViewController.newTweet))
        // テキストフィールドにフォーカスを合わせる
        tweetTextView.becomeFirstResponder()
    }
    
    // [navBar 左]閉じるボタンが押された時の処理
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // [navBar 右]投稿ボタンを押した時の処理
    @objc func newTweet() {
        //TODO: データ投稿処理を記述する
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSelectPhotoButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// ImagePicker（画像取得）についてのエクステンション
extension SendTweetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // キャンセルボタンを押された時に呼ばれる
        self.dismiss(animated: true, completion: nil)
    }
    
    // 写真が選択された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 写真取得
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        tweetPhotoimageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}

extension SendTweetViewController: UITextViewDelegate {
    // UITextViewデリゲートメソッド（textに変更があった際に呼び出される。）
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight = 200.0  // 入力フィールドの最大サイズ
        if(textView.frame.size.height.native < maxHeight) {
            let size:CGSize = tweetTextView.sizeThatFits(tweetTextView.frame.size)
            tweetTextView.frame.size.height = size.height
        }
    }
}
