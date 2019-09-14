//
//  ImageSelectionActionSheetController.swift
//  RDGalleryPicker
//
//  Created by Deniz Mersinlioğlu on 14.09.2019.
//  Copyright © 2019 Development House. All rights reserved.
//

import UIKit

class ImageSelectionActionSheetController: UIViewController, UICollectionViewDelegateFlowLayout{
    @IBOutlet var selectionCollectionView: UICollectionView!
    let selectionCellId = "ImageSelectionCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: selectionCellId, bundle: nil)
        selectionCollectionView.register(nib, forCellWithReuseIdentifier: selectionCellId)
        selectionCollectionView.delegate = self
        selectionCollectionView.dataSource = self
        selectionCollectionView.backgroundColor = .red
    }
    
    @IBOutlet var cancelButton: UIButton!
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("Cancel Button Pressed")
    }
}

extension ImageSelectionActionSheetController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(id: selectionCellId, indexPath: indexPath) as! ImageSelectionCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
}

extension ImageSelectionActionSheetController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item selected at \(indexPath)")
    }
}
