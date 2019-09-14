//
//  UtilityController.swift
//  RDGalleryPicker
//
//  Created by Deniz Mersinlioğlu on 14.09.2019.
//  Copyright © 2019 Development House. All rights reserved.
//

import UIKit

class UtilityController: UIViewController {
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var utilityView: UIView!
    @IBOutlet var background: UIView!
    @IBOutlet var headerTitle: UILabel!
    
    var imageSelectionSheetController: ImageSelectionActionSheetController?
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "imageSelectionSheet":
            imageSelectionSheetController = segue.destination as? ImageSelectionActionSheetController
        default: break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setState(open: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(open: false)
    }
    
    @IBAction func backgroundTap(_ sender: Any) {
        dismissUtility()
    }
    
    fileprivate func setState(open: Bool, completion: (()->())? = nil){
        bottomConstraint.constant = open ? 0 : -self.utilityView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.background.alpha = open ? 1 :0
        }) { _ in
            completion?()
        }
    }
    
    @objc func dismissUtility(){
        setState(open: false) {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

enum Utility {
    case imageSelectionSheet

    var controller: UtilityController {
        let controller = createController()
        controller.loadViewIfNeeded()
        return controller
    }
    
    func createController() -> UtilityController {
        switch self {
        case .imageSelectionSheet:
            let storyBoard = UIStoryboard(name: "ImageSelectionUtility", bundle: nil)
            return storyBoard.instantiateInitialViewController() as! UtilityController
        }
    }
}
