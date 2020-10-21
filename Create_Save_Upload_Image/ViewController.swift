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
    @IBOutlet weak var ibTrashImage: UIImageView!
    var imageView: UIImageView!
    var docOrigin: CGPoint!
    override func viewDidLoad() {
        super.viewDidLoad()
        ibPaPaImageView.image = UIImage(named: "papa")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ibAddTapped(_ sender: UIButton) {
        let image = UIImage(systemName: "heart")
        imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        ibPaPaImageView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(draged(sender:)))
        imageView.addGestureRecognizer(pan)
        docOrigin = imageView.frame.origin
        
        ibPaPaImageView.addSubview(imageView)
    }
    
    @IBAction func ibSaveTapped(_ sender: UIButton) {
    }
    
    @IBAction func ibUploadTapped(_ sender: UIButton) {
    }
    
    @objc func draged(sender: UIPanGestureRecognizer) {
        guard let docView = sender.view else { return }
        
        switch sender.state {
        case .began, .changed:
            movingDocImage(view: docView, sender: sender)
        case .ended:
            if imageView.frame.intersects(ibTrashImage.frame) {
                deleteDocImage()
            } else {
                //                backDocImageToOrigin()
            }
            break
        default:
            break
        }
    }
    
    func movingDocImage(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        //           view.frame.origin = CGPoint(x: view.frame.origin.x + translation.x, y: view.frame.origin.y + translation.y)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func backDocImageToOrigin() {
        UIView.animate(withDuration: 0.3) {
            self.imageView.frame.origin = self.docOrigin
        }
    }
    
    func deleteDocImage() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.imageView.alpha = 0
        })
    }
    
    func addGesture() {
    }
    
    func removeGesture() {
        
    }
}

