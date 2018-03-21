//
//  PlaceDetailsController.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/21/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import UIKit
import Kingfisher

class PlaceDetailsController: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var addressLabel: UILabel!
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = place.name
        addressLabel.text = place.address
        if !place.photos.isEmpty {
            imageView.kf.setImage(with: place.photos.last!.url(apiKey: GoogleAPIKey, baseUrl: GooglePlacesBaseUrl).absoluteURL)
        }
    }

    // MARK: - Actions
    @IBAction func didPressAddToFavorites(_ sender: Any) {
        store.dispatch(MapAction.addToFavorites(place: place))
    }
}
