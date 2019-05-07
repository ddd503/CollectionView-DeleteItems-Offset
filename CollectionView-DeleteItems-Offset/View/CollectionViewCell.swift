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
    
    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    override func prepareForReuse() {
        contentView.backgroundColor = .white
    }

    func setText(_ text: String?) {
        textLabel.text = text
    }

    func setBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }

}
