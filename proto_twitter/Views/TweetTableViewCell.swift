//
//  TweetTableViewCell.swift
//  proto_twitter
//
//  Created by fukuda_kosuke on 2018/12/06.
//  Copyright © 2018 福田光祐. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetImageCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // xibファイルの登録(ツイート投稿画像)
        let nib = UINib(nibName: "TweetImageCollectionViewCell", bundle: nil) // カスタムセルクラス名で`nib`を作成する
        tweetImageCollectionView.register(nib, forCellWithReuseIdentifier: "TweetImageCollectionViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// CollectionViewのdelegateを登録し、データをリロードする
    ///
    /// - Parameters:
    ///   - dataSourceDelegate:
    ///   - row:
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        tweetImageCollectionView.delegate   = dataSourceDelegate
        tweetImageCollectionView.dataSource = dataSourceDelegate
        tweetImageCollectionView.reloadData()
        
    }

}
