//
//  ImageSelectionActionSheetController.swift
//  RDGalleryPicker
//
//  Created by Deniz Mersinlioğlu on 14.09.2019.
//  Copyright © 2019 Development House. All rights reserved.
//

import UIKit
import Photos

protocol ImageSelectionActionSheetDelegate: class {
    func closeButtonPressed()
}


class ImageSelectionActionSheetController: UIViewController, UICollectionViewDelegateFlowLayout{
    @IBOutlet var selectionCollectionView: UICollectionView!
    @IBOutlet var cancelButton: UIButton!
    
    var images: [ImageHolder] = []
    let library = ImagesLibrary()
    var selectedAlbum: Album?
    var once: Once!
    var fetching: Bool = false
    var initialFetchCount: Int = 20
    weak var delegate: ImageSelectionActionSheetDelegate?
    
    let selectionCellId = "ImageSelectionCollectionViewCell"
    
    func fetchImage(count: Int){
        once.run(for: count) {
            print("--- Fetch album for count: \(count)")
            fetching = true
            library.reload(limit: count) {
                guard let album = self.library.albums.first else {return}
                self.selectedAlbum = album
                self.show(album: album)
            }
        }
    }
    
    func show(album: Album) {
        let taskGroup = DispatchGroup()
        let old = self.images
        
        album.items
            .filter { !images.map{ $0.diffId }.contains($0.asset.hashValue)}
            .forEach { item in
            taskGroup.enter()
            let size = CGSize(width: 120, height: 120)
            item.resolve(size: size, completion: {
                guard let image = $0 else {return}
                let holder = ImageHolder(from: image, asset: item.asset)
                self.images.append(holder)
                taskGroup.leave()
            })
        }
        
        taskGroup.notify(queue: .main) {
            let new = self.images.sorted{ $0 > $1 }
            let changes = diff(old: old, new: new)
            print("--- Collection View Reloaded for Count: \(self.images.count)")
            self.selectionCollectionView.reload(changes: changes, updateData: {
                self.images = new
            })
            self.fetching = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.once = Once()
        fetchImage(count: initialFetchCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: selectionCellId, bundle: nil)
        selectionCollectionView.register(nib, forCellWithReuseIdentifier: selectionCellId)
        selectionCollectionView.delegate = self
        selectionCollectionView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.images.removeAll()
        self.selectionCollectionView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("Cancel Button Pressed")
        delegate?.closeButtonPressed()
    }
}

extension ImageSelectionActionSheetController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(id: selectionCellId, indexPath: indexPath) as! ImageSelectionCollectionViewCell
        cell.setup(with: images[indexPath.item].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Item will appear: \(indexPath.item)")
        guard Double(indexPath.item) > Double(images.count) - 5,
            !self.fetching else {return}
        self.fetchImage(count: images.count + self.initialFetchCount)
    }
}

extension ImageSelectionActionSheetController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item selected at \(indexPath)")
    }
}
