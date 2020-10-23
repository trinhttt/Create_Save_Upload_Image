//
//  BabyView.swift
//  Create_Save_Upload_Image
//
//  Created by TrinhThai on 10/22/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit


struct Sticker {
    var name: String?
    var sticker: UIImage?
}

class StickerView: UIView, UIGestureRecognizerDelegate {
    private var localTouchPosition : CGPoint?
    private var identity = CGAffineTransform.identity
    var resetHandler:(()->())?
    private var resetButton: UIButton!
    private var isButtonVisible = false
    private let padding: CGFloat = 15.0
    var isSelected = true {
        didSet {
            if isSelected {
                showControlPanel()
                addGesture()
            } else {
                hideControlPanel()
                removeGesture()
            }
        }
    }
    private var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(closeButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private var stickerImageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var stickerImage:UIImage? {
        didSet{
            stickerImageView.image = stickerImage
            stickerImageView.backgroundColor = .yellow
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- All setup goes here for image view
    private func setup(){
        
        addSubview(stickerImageView)
        stickerImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
        stickerImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        stickerImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        stickerImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        
        
        addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        if #available(iOS 13.0, *) {
            let width: CGFloat = 48
            let height: CGFloat = width
            resetButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            resetButton.center = CGPoint(x: padding, y: padding)
            resetButton.setImage(UIImage(systemName: "repeat"), for: .normal)
            resetButton.addTarget(self, action: #selector(setResetButton), for: .touchUpInside)
            self.addSubview(resetButton)
        } else {
            // Fallback on earlier versions
        }
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(rotationGesture)
        addGestureRecognizer(tapGesture)
        
        showCloseButton()
        //        hideCloseButton()
    }
    @objc private func closeButtonDidTap(_ sender:UIButton){
        removeFromSuperview()
    }
    
    func showControlPanel() {
        closeButton.isHidden = false
        resetButton.isHidden = false
        isButtonVisible = true
        self.layer.borderWidth = 1
    }
    
    func hideControlPanel() {
        closeButton.isHidden = true
        resetButton.isHidden = true
        self.isButtonVisible = false
    }
    
    private func hideCloseButton(){
        if isButtonVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.closeButton.isHidden = true
                self.isButtonVisible = false
                self.layer.borderWidth = 0
            }
        }
    }
    
    private func showCloseButton(){
        self.closeButton.isHidden = false
        isButtonVisible = true
        self.layer.borderWidth = 1
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        if isButtonVisible {
            hideControlPanel()
        }else{
            showControlPanel()
        }
    }
    
    
    //MARK:- Function to handle scaling of imageview
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = transform
        case .changed,.ended:
            transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    
    //MARK:- Function to handle rotation of imageview
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        transform = transform.rotated(by: gesture.rotation)
    }
    
    
    //MARK:- Gesture Recognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    //MARK:- Function to handle moving of imageview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.superview) else { return }
        // Store localTouchPosition relative to center
        self.localTouchPosition = CGPoint(x: location.x - self.center.x, y: location.y - self.center.y)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        guard let location = touch?.location(in: self.superview), let localTouchPosition = self.localTouchPosition else{
            return
        }
        self.center = CGPoint(x: location.x - localTouchPosition.x, y: location.y - localTouchPosition.y)
    }
    //MARK:- Add
    
    
    func addGesture() {
        
    }
    
    func removeGesture() {
        
    }
    
    
    @objc func deleteButtonPressed(sender: UIButton) {
        removeFromSuperview()
    }
    
    @objc func setResetButton() {
        self.resetHandler?()
    }
    
}
