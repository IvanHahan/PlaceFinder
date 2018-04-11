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
        imageView.center = view.center
        imageView.tag = currentImageIndex
        imageView.isUserInteractionEnabled = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        imageView.addGestureRecognizer(panRecognizer)
        
        view.addSubview(imageView)
        
        currentImageIndex = currentImageIndex >= images.count - 1 ? 0 : currentImageIndex + 1
    }
    
    @objc private func didPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: view)
        default:()
        }
    }
}

