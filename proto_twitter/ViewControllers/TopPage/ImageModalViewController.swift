//
//  ImageModalViewController.swift
//  proto_twitter
//
//  Created by fukuda_kosuke on 2018/12/07.
//  Copyright © 2018 福田光祐. All rights reserved.
//

import UIKit

class ImageModalViewController: UIViewController {
    
    var message:String?
    var image:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.green
        print(message ?? "値がセットされていない")
        
        let imageView = UIImageView(image: image)
        // 画面の横幅を取得
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        // 画像の中心を画面の中心に設定
        imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
        // UIImageViewのインスタンスをビューに追加
        self.view.addSubview(imageView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
