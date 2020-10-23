//
//  ViewController.swift
//  Create_Save_Upload_Image
//
//  Created by Trinh Thai on 10/22/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ibPaPaImageView: UIImageView!
    @IBOutlet weak var ibWrapperView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibPaPaImageView.image = UIImage(named: "papa")
    }
    
    @IBAction func ibAddTapped(_ sender: UIButton) {
         createSticker()
    }
    
    fileprivate func createSticker() {
        allBabyViewUnSelected()
        let sticker = UIImage(systemName: "heart")!
        let width = 100
        let height = 100
        let stickerView = StickerView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        stickerView.center = view.center
        stickerView.stickerImage = sticker
        stickerView.resetHandler = {
            stickerView.removeFromSuperview()
            self.createSticker()
        }
        
        ibWrapperView.addSubview(stickerView)
    }
    
    private func createEditedImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: ibWrapperView.bounds)
            return renderer.image { rendererContext in
                ibWrapperView.layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(ibWrapperView.frame.size)
            ibWrapperView.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    @IBAction func ibSaveTapped(_ sender: UIButton) {
        let image = createEditedImage()
        let directoryManager = DirectoryManager(folder: .final)
        let fileName = UUID()
        directoryManager.saveImage(image: image, fileName: "\(fileName)")
        
    }
    
    @IBAction func ibUploadTapped(_ sender: UIButton) {
    }
    
    func addGesture() {
    }
    
    func removeGesture() {
        
    }
    
    private func allBabyViewUnSelected() {
        for subview in ibWrapperView.subviews {
            guard let subview = subview as? StickerView else { continue }
            subview.isSelected = false
        }
    }
    
    @IBAction func ibViewTapped(_ sender: Any) {
        self.allBabyViewUnSelected()
    }
}

