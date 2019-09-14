//
//  ViewController.swift
//  RDGalleryPicker
//
//  Created by Deniz Mersinlioğlu on 14.09.2019.
//  Copyright © 2019 Development House. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, GalleryControllerDelegate {
    
    var button: UIButton!
    var actionSheetButton: UIButton!
    var gallery: GalleryController!
    let editor: VideoEditing = VideoEditor()
    
    private lazy var imageSelectionActionSheet: UtilityController = {
        let utility = Utility.imageSelectionSheet.controller
        return utility
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        Config.tabsToShow = [.cameraTab, .imageTab]
        Config.VideoEditor.savesEditedVideoToLibrary = true
        
        button = UIButton(type: .system)
        button.frame.size = CGSize(width: 200, height: 50)
        button.setTitle("Open RDGallery", for: UIControl.State())
        button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)
        button.isHidden = true
        
        actionSheetButton = UIButton(type: .system)
        actionSheetButton.frame.size = CGSize(width: 200, height: 50)
        actionSheetButton.setTitle("Open Action Sheet", for: UIControl.State())
        actionSheetButton.addTarget(self, action: #selector(actionSheetButtonTouched(_:)), for: .touchUpInside)
        
        view.addSubview(actionSheetButton)
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        actionSheetButton.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        button.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
    }
    
    @objc func buttonTouched(_ button: UIButton) {
        gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    @objc func actionSheetButtonTouched(_ button: UIButton) {
        present(imageSelectionActionSheet, animated: false) {
            print("Action Sheet presented")
        }
    }

    // MARK: - GalleryControllerDelegate
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
        editor.edit(video: video) { (editedVideo: Video?, tempPath: URL?) in
            DispatchQueue.main.async {
                if let tempPath = tempPath {
                    let controller = AVPlayerViewController()
                    controller.player = AVPlayer(url: tempPath)
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        //TODO: - SVProgressHUD.show() -> Create a loader to indicate loading process
        
        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            //TODO: - SVProgressHUD.dismiss() -> Dismiss the loader to indicate loading process ends
            guard let self = self else {return}
            let compactImages = resolvedImages.compactMap{$0}
            let agrume = Agrume(images: compactImages)
            agrume.show(from: self.gallery, color: .black)
        })
    }
}
