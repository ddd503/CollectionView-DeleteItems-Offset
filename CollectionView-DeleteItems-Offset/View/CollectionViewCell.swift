//
//  CollectionViewCell.swift
//  CollectionView-DeleteItems-Offset
//
//  Created by kawaharadai on 2019/05/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var checkImageView: UIImageView!
    @IBOutlet weak private var whiteView: UIView!

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override var isSelected: Bool {
        didSet {
            whiteView.isHidden = !isSelected
            checkImageView.isHidden = !isSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    override func prepareForReuse() {
        isSelected = false
        contentView.backgroundColor = .white
    }

    func setInfo(tag: Int) {
        self.tag = tag
        textLabel.text = String(tag)
    }

    func setBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }

}
