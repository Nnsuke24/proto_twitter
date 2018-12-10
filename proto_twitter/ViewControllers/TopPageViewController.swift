//
//  TopPageViewController.swift
//  proto_twitter
//
//  Created by fukuda_kosuke on 2018/12/05.
//  Copyright © 2018 福田光祐. All rights reserved.
//

import UIKit

class TopPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var profileViewController = ProfileViewController()
    private var isShownSidemenu: Bool {
        return profileViewController.parent == self
    }
    
    @IBOutlet weak var timelineTableView: UITableView!
    var catImage = UIImage(named: "cat.PNG")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "トップページ"
        
        // デリゲートなどを登録
        profileViewController.delegate = self
        timelineTableView.delegate     = self
        timelineTableView.dataSource   = self
        // セルの高さが動的に変わるようにする
        timelineTableView.estimatedRowHeight = 50
        timelineTableView.rowHeight = UITableViewAutomaticDimension
        
        profileViewController.startPanGestureRecognizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ナビゲーションバー右のボタンを設定
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "投稿", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(TopPageViewController.newTweet))
    }
    
    @objc func newTweet() {
        self.performSegue(withIdentifier: "PresentNewTweetViewController", sender: self)
    }   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// サイドメニューを表示する
    ///
    /// - Parameters:
    ///   - contentAvailability:
    ///   - animated:
    private func showSidemenu(contentAvailability: Bool = true, animated: Bool) {
        if isShownSidemenu { return }
        
        addChildViewController(profileViewController)
        profileViewController.view.autoresizingMask = .flexibleHeight
        profileViewController.view.frame = self.view.bounds
        view.insertSubview(profileViewController.view, aboveSubview: self.view)
        profileViewController.didMove(toParentViewController: self)
        if contentAvailability {
            profileViewController.showContentView(animated: animated)
        }
    }
    
    /// サイドメニューを隠す
    ///
    /// - Parameter animated:
    private func hideSidemenu(animated: Bool) {
        if !isShownSidemenu { return }
        
        profileViewController.hideContentView(animated: animated, completion: { (_) in
            self.profileViewController.willMove(toParentViewController: nil)
            self.profileViewController.removeFromParentViewController()
            self.profileViewController.view.removeFromSuperview()
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tweetCell = cell as? TweetTableViewCell else { return }
        
        tweetCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    /// セルの中身を設定する
    ///
    /// - Parameters:
    ///   - tableView: タイムラインのTableView
    ///   - indexPath: セルの番号
    /// - Returns: セル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = timelineTableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetTableViewCell
        tweetCell.iconImageView.image = catImage
        tweetCell.userNameLabel.text  = "ガッキー"
        tweetCell.userIdLabel.text    = "@sample"
        tweetCell.tweetLabel.text     = "あああああああああああああああああああああああああああああああ"
        
        return tweetCell
    }
    
    /// セルの数を設定する
    ///
    /// - Parameters:
    ///   - tableView: タイムラインのTableView
    ///   - section: セクション
    /// - Returns: セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    /// セルの高さの設定
    ///
    /// - Parameters:
    ///   - tableView:
    ///   - indexPath:
    /// - Returns: セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 20 //セルの高さ(初期設定)
        return UITableViewAutomaticDimension
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// プロフィールViewControllerを操作するためのエクステンション
extension TopPageViewController: ProfileViewControllerDelegate {
    func parentViewControllerForProfileViewController(_ sidemenuViewController: ProfileViewController) -> UIViewController {
        return self
    }
    
    func shouldPresentForProfileViewController(_ sidemenuViewController: ProfileViewController) -> Bool {
        /* You can specify sidemenu availability */
        return true
    }
    
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: ProfileViewController, contentAvailability: Bool, animated: Bool) {
        showSidemenu(contentAvailability: contentAvailability, animated: animated)
    }
    
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: ProfileViewController, animated: Bool) {
        hideSidemenu(animated: animated)
    }
    
    func sidemenuViewController(_ sidemenuViewController: ProfileViewController, didSelectItemAt indexPath: IndexPath) {
        hideSidemenu(animated: true)
    }
}

// テーブルセル内のコレクションビューを操作するためのエクステンション
extension TopPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate{
    
    /// ツイート画像要素数
    //TODO: 登録されている画像数による場合分けはここで行う
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /// セル（ツイート画像）の設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let tweetImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetImageCollectionViewCell", for: indexPath) as! TweetImageCollectionViewCell
        let imageView = tweetImageCollectionViewCell.tweetImageView!
        
        imageView.image = catImage
        
        // ジェスチャー追加：画像をタップした際にモーダルウィンドウを開く
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(TopPageViewController.imageViewTapped(_:)))
        )
        
        return tweetImageCollectionViewCell
    }
    
    /// 画像をタップした際にモーダルを表示する関数
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        print("画像タップ")
        let imageModalViewController = ImageModalViewController()
        // モーダルスタイルをカスタマイズとする
        imageModalViewController.modalPresentationStyle = .custom
        imageModalViewController.transitioningDelegate = self
        imageModalViewController.message = "こんにちは"
        imageModalViewController.image = catImage
            present(imageModalViewController, animated: true, completion: nil)
        
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return TweetImagePresentationController(presentedViewController: presented, presenting: presenting)
    }

}
