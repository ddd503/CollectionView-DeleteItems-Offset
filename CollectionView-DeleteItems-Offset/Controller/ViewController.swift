//
//  ViewController.swift
//  CollectionView-DeleteItems-Offset
//
//  Created by kawaharadai on 2019/05/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    private let cellCount = 50
    private var numbers = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numbers = (0 ..< cellCount).map { $0 }
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib(),
                                forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
    }

    @IBAction func didTapDelete(_ sender: UIButton) {
        guard let deleteIndexPaths = collectionView.indexPathsForSelectedItems,
            !deleteIndexPaths.isEmpty else {
                showAlert(message: "選択中のセルがありません。")
                return
        }

        guard let customLayout = collectionView.collectionViewLayout as? CollectionViewCustomLayout else {
            showAlert(message: "レイアウト情報の取得に失敗しました。")
            return
        }
        // trueをセットすることで、次のレイアウト更新時には現在のoffsetが保持される
        customLayout.isKeepCurrentOffset = true

        // 選択したセルの削除
        let deleteNumbers = deleteIndexPaths.compactMap { (collectionView.cellForItem(at: $0) as? CollectionViewCell)?.tag }
        numbers = numbers.filter { !deleteNumbers.contains($0) }
        collectionView.deleteItems(at: deleteIndexPaths)
    }

    @IBAction func didTapAllRestore(_ sender: UIButton) {
        let deletedNumbers = (0 ..< cellCount).filter { !numbers.contains($0) }
        guard !deletedNumbers.isEmpty else {
            showAlert(message: "削除したセルはありません。")
            return
        }

        numbers = (0 ..< cellCount).map { $0 }
        collectionView.insertItems(at: deletedNumbers.map { IndexPath(item: $0, section: 0) })
    }

    private func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "とじる", style: .default, handler: nil)
        alert.addAction(close)
        present(alert, animated: true)
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        let tagNumber = numbers[indexPath.item]
        cell.setInfo(tag: tagNumber)
        if tagNumber % 2 == 0 {
            cell.setBackgroundColor(.lightGray)
        }
        return cell
    }
}
