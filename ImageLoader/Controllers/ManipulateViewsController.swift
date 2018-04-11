//
//  ManipulateViewsController.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 4/11/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import UIKit

class ManipulateViewsController: UIViewController {

    private let images = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5")]
    private var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func didPressAdd(_ sender: Any) {
        
        let imageView = UIImageView(image: images[currentImageIndex])
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = view.center
        imageView.isUserInteractionEnabled = true
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        panRecognizer.delegate = self
        imageView.addGestureRecognizer(panRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
        pinchRecognizer.delegate = self
        imageView.addGestureRecognizer(pinchRecognizer)
        
        let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(sender:)))
        rotateRecognizer.delegate = self
        imageView.addGestureRecognizer(rotateRecognizer)
        
        view.addSubview(imageView)
        
        currentImageIndex = currentImageIndex >= images.count - 1 ? 0 : currentImageIndex + 1
    }
    
    @objc private func didPan(sender: UIPanGestureRecognizer) {
        if let view = sender.view {
            let translation = sender.translation(in: view)
            view.transform = view.transform.translatedBy(x: translation.x, y: translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func didPinch(sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    
    @objc private func didRotate(sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
}

extension ManipulateViewsController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
