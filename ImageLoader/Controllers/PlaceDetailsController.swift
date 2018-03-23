//
//  PlaceDetailsController.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/21/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import UIKit
import Kingfisher
import ReSwift

class PlaceDetailsController: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var addressLabel: UILabel!
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.subscribe(self) {
            $0.select {
                $0.placeDetailsState
            }
        }
        setupUI()
    }
    
    private func setupUI() {
        nameLabel.text = place.name
        addressLabel.text = place.address
        if !place.photos.isEmpty {
            imageView.kf.setImage(with: place.photos.last!.url(apiKey: GoogleAPIKey, baseUrl: GooglePlacesBaseUrl).absoluteURL)
        }
    }

    // MARK: - Actions
    @IBAction func didPressAddToFavorites(_ sender: Any) {
        store.dispatch(addToFavorites(place: place))
    }
}

extension PlaceDetailsController: StoreSubscriber {
    func newState(state: PlaceDetailsState) {
        switch state {
        case .saved:
            let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            store.dispatch(Default())
        default: ()
        }
    }
}
