//
//  ProfileViewController.swift
//  proto_twitter
//
//  Created by fukuda_kosuke on 2018/12/06.
//  Copyright © 2018 福田光祐. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    func parentViewControllerForProfileViewController(_ sidemenuViewController: ProfileViewController) -> UIViewController
    func shouldPresentForProfileViewController(_ sidemenuViewController: ProfileViewController) -> Bool
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: ProfileViewController, contentAvailability: Bool, animated: Bool)
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: ProfileViewController, animated: Bool)
    func sidemenuViewController(_ sidemenuViewController: ProfileViewController, didSelectItemAt indexPath: IndexPath)
}

class ProfileViewController: UIViewController {
    
    // UIView
    private let contentView     = UIView(frame: .zero)
    private var iconImageView:UIImageView?
    private let userNameLabel   = UILabel(frame: .zero)
    private let userIdLabel     = UILabel(frame: .zero)
    private var followNumLabel  = UILabel(frame: .zero)
    private let followLabel     = UILabel(frame: .zero)
    private var followerNumLabel = UILabel(frame: .zero)
    private let followerLabel   = UILabel(frame: .zero)
    private let tableView       = UITableView(frame: .zero, style: .plain)
    
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    weak var delegate: ProfileViewControllerDelegate?
    private var beganLocation: CGPoint = .zero
    private var beganState: Bool = false
    var isShown: Bool {
        return self.parent != nil
    }
    // 横スワイプで出てくる幅の比率
    private var contentMaxWidth: CGFloat {
        return view.bounds.width * 0.8
    }
    // 影や背景など見た目の調整
    private var contentRatio: CGFloat {
        get {
            return contentView.frame.maxX / contentMaxWidth
        }
        set {
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentRect.origin.x = -contentRect.width
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        let x      = contentView.bounds.origin.x
        let y      = contentView.bounds.origin.y
        let width  = contentView.bounds.size.width
        let height = contentView.bounds.size.height
        let startPointOfX = x + 8
        
        // アイコン
        let iconFrame = CGRect(x: startPointOfX,
                               y: y + 70,
                               width: 70,
                               height: 70)
        iconImageView = UIImageView(frame: iconFrame)
        iconImageView?.image = UIImage(named: "cat.PNG")
        iconImageView!.contentMode = UIViewContentMode.scaleAspectFill
        iconImageView!.clipsToBounds = true
        // ユーザー名
        userNameLabel.frame = CGRect(x: startPointOfX ,
                                     y: iconImageView!.frame.origin.y +
                                        iconImageView!.frame.size.height,
                                     width : 150,
                                     height: 30)
        userNameLabel.text  = "User Name"
        // ユーザID
        userIdLabel.frame = CGRect(x: startPointOfX,
                                   y: userNameLabel.frame.origin.y +
                                      userNameLabel.frame.size.height,
                                   width: 150,
                                   height: 30)
        userIdLabel.text  = "User ID"
        
        let followStartPointOfY = userIdLabel.frame.origin.y +
            userIdLabel.frame.size.height
        // フォロー
        followNumLabel.frame = CGRect(x: startPointOfX,
                                      y: followStartPointOfY,
                                      width: 30,
                                      height: 30)
        followNumLabel.text = String(0)
        followNumLabel.textAlignment = .center
        followLabel.frame = CGRect(x: startPointOfX + followNumLabel.frame.size.width,
                                   y: followStartPointOfY ,
                                   width: 90,
                                   height: 30)
        followLabel.text = "フォロー"
        // フォロワー
        followerNumLabel.frame = CGRect(x: startPointOfX + followNumLabel.frame.size.width +
                                         followLabel.frame.size.width,
                                      y: followStartPointOfY ,
                                      width: 30,
                                      height: 30)
        followerNumLabel.text = String(0)
        followerNumLabel.textAlignment = .center
        followerLabel.frame = CGRect(x: startPointOfX + followNumLabel.frame.size.width +
                                followLabel.frame.size.width + followerNumLabel.frame.size.width,
                                   y: followStartPointOfY ,
                                   width: 90,
                                   height: 30)
        followerLabel.text = "フォロワー"
        // テーブルビュー
        tableView.frame = CGRect(x: x,
                                 y: followStartPointOfY + followNumLabel.frame.size.height,
                                 width: width,
                                 height: height - (followStartPointOfY + followNumLabel.frame.size.height))
//        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        // 子ビューとして追加
        self.contentView.addSubview(iconImageView!)
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(userIdLabel)
        self.contentView.addSubview(followNumLabel)
        self.contentView.addSubview(followLabel)
        self.contentView.addSubview(followerNumLabel)
        self.contentView.addSubview(followerLabel)
        self.contentView.addSubview(tableView)
        tableView.reloadData()
        
        // メニュー以外の半透明の薄暗い部分をタップした時も非表示にする
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// 背景がタップされた時の処理
    ///
    /// - Parameter sender: タップジェスチャー
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParentViewController: nil)
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    
    // コンテンツを表示させる関数
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        } else {
            contentRatio = 1.0
        }
    }
    
    // コンテンツビューを隠す
    func hideContentView(animated: Bool, completion: ((Bool) -> Swift.Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0 //contentRatio が 0 になるようにしている。
            }, completion: { (finished) in
                completion?(finished)
            })
        } else {
            contentRatio = 0
            completion?(true)
        }
    }
    
    /// パンジェスチャーを登録する
    func startPanGestureRecognizing() {
        if let parentViewController = self.delegate?.parentViewControllerForProfileViewController(self) {
            // スクリーンの端からのパンジェスチャー
            screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            screenEdgePanGestureRecognizer.edges = [.left]
            screenEdgePanGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
            
            // 画面上のパンジェスチャー
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    /// パンジェスチャーの結果を判断する
    ///
    /// - Parameter panGestureRecognizer: パンジェスチャー
    @objc private func panGestureRecognizerHandled(panGestureRecognizer: UIPanGestureRecognizer) {
        guard let shouldPresent = self.delegate?.shouldPresentForProfileViewController(self), shouldPresent else {
            return
        }
        
        // 既に表示されている際の右方向のPANジェスチャーは無視
        let translation = panGestureRecognizer.translation(in: view)
        if translation.x > 0 && contentRatio == 1.0 {
            return
        }
        
        let location = panGestureRecognizer.location(in: view)
        switch panGestureRecognizer.state {
        case .began:
            beganState = isShown
            beganLocation = location
            if translation.x  >= 0 {
                self.delegate?.sidemenuViewControllerDidRequestShowing(self, contentAvailability: false, animated: false)
            }
        case .changed:
            let distance = beganState ? beganLocation.x - location.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
            
        case .ended, .cancelled, .failed:
            if contentRatio <= 1.0, contentRatio >= 0 {
                if location.x > beganLocation.x {
                    showContentView(animated: true)
                } else {
                    self.delegate?.sidemenuViewControllerDidRequestHiding(self, animated: true)
                }
            }
            beganLocation = .zero
            beganState = false
        default: break
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sidemenuViewController(self, didSelectItemAt: indexPath)
    }
}

// テーブルViewへのタップはジェスチャーを無効にしている
extension ProfileViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil {
            return false
        }
        return true
    }
}
