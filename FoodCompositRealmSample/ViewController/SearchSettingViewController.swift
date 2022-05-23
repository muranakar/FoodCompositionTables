//
//  SearchSettingViewController.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/05/23.
//

import UIKit

class SearchSettingViewController: UIViewController {
    
    //選択した結果のカテゴリで検索
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private let sideMargin: CGFloat = 1
    private let itemPerWidth: CGFloat = 2
    private let itemSpacing: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: sideMargin,
                                           bottom: 10,
                                           right: sideMargin)
        layout.minimumInteritemSpacing = itemSpacing
        categoryCollectionView.collectionViewLayout = layout
    }
}

extension SearchSettingViewController: UICollectionViewDelegate {
    
}

extension SearchSettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
}

extension SearchSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
         // セルの割当に利用可能なwidth
         // :親viewのwidth - 左右のマージン - セル間の水平方向の間隔 * (列数 - 1)
         let availableWidth = (view.frame.width - sideMargin * 2) - itemSpacing * (itemPerWidth - 1)
         // セル一つのwidth
         let width = availableWidth / itemPerWidth
        return CGSize(width: width, height: width * 2 / 4)
     }
}
