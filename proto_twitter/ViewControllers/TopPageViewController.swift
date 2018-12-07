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
    
    /// セルの中身を設定する
    ///
    /// - Parameters:
    ///   - tableView: タイムラインのTableView
    ///   - indexPath: セルの番号
    /// - Returns: セル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = timelineTableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetTableViewCell
        tweetCell.iconImageView.image = UIImage(named: "cat.PNG")
        tweetCell.nameLabel.text  = "テスト"
        tweetCell.tweetLabel.text = "あああああああああああああああああああああああああああああああ"
        
        
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
        tableView.estimatedRowHeight = 20 //セルの高さ
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

