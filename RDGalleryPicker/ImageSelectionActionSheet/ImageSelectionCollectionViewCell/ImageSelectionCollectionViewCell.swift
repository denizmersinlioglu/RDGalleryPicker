//
//  ImageSelectionCollectionViewCell.swift
//  RDGalleryPicker
//
//  Created by Deniz Mersinlioğlu on 14.09.2019.
//  Copyright © 2019 Development House. All rights reserved.
//

import UIKit

class ImageSelectionCollectionViewCell: UICollectionViewCell{
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .blue
        self.imageView.image = nil
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func setup(with image: UIImage?){
        self.imageView.image = image
    }
    
}
