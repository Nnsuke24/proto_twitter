//
//  TopPageViewController.swift
//  proto_twitter
//
//  Created by fukuda_kosuke on 2018/12/05.
//  Copyright © 2018 福田光祐. All rights reserved.
//

import UIKit

class TopPageViewController: UIViewController {
    
    let contentViewController = UINavigationController(rootViewController: UIViewController())
    var profileViewController = ProfileViewController()
    private var isShownSidemenu: Bool {
        return profileViewController.parent == self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "トップページ"

        contentViewController.viewControllers[0].view.backgroundColor = .white
//        contentViewController.viewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sidemenu", style: .plain, target: self, action: #selector(sidemenuBarButtonTapped(sender:)))
        addChildViewController(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParentViewController: self)
        
        // プロフィールViewControllerの再初期化
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.delegate = self
        profileViewController.startPanGestureRecognizing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @objc private func sidemenuBarButtonTapped(sender: Any) {
//        showSidemenu(animated: true)
//    }
    
    private func showSidemenu(contentAvailability: Bool = true, animated: Bool) {
        if isShownSidemenu { return }
        
        addChildViewController(profileViewController)
        profileViewController.view.autoresizingMask = .flexibleHeight
        profileViewController.view.frame = contentViewController.view.bounds
        view.insertSubview(profileViewController.view, aboveSubview: contentViewController.view)
        profileViewController.didMove(toParentViewController: self)
        if contentAvailability {
            profileViewController.showContentView(animated: animated)
        }
    }
    
    private func hideSidemenu(animated: Bool) {
        if !isShownSidemenu { return }
        
        profileViewController.hideContentView(animated: animated, completion: { (_) in
            self.profileViewController.willMove(toParentViewController: nil)
            self.profileViewController.removeFromParentViewController()
            self.profileViewController.view.removeFromSuperview()
        })
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

