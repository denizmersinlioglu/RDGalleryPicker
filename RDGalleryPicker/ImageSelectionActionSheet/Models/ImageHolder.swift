//
//  ImageHolder.swift
//  RDGalleryPicker
//
//  Created by Deniz Mersinlioğlu on 14.09.2019.
//  Copyright © 2019 Development House. All rights reserved.
//

import Foundation
import Photos

struct ImageHolder: DiffAware, Hashable {
    public typealias DiffId = Int
    
    public var diffId: DiffId {
        return identifier
    }
    
    public static func compareContent(_ a: ImageHolder, _ b: ImageHolder) -> Bool{
        return a.identifier == b.identifier
    }
    
    public static func > (lhs: ImageHolder, rhs: ImageHolder) -> Bool{
        return lhs.creationDate ?? Date() > rhs.creationDate ?? Date()
    }
    
    var image: UIImage
    var identifier: Int
    var creationDate: Date?
    
    init(from image: UIImage, asset: PHAsset){
        self.image = image
        self.identifier = asset.hashValue
        self.creationDate = asset.creationDate
    }
    
    init(image: UIImage, identifier: Int) {
        self.image = image
        self.identifier = identifier
    }
}
