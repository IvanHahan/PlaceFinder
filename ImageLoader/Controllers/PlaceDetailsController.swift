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
import CoreLocation

class PlaceDetailsController: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var addressLabel: UILabel!
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.placeDetailsState
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
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

// MARK: - StoreSubscriber

extension PlaceDetailsController: StoreSubscriber {
    func newState(state: State) {
        switch state {
        case .saved:
            let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
}

// MARK: - RE

extension PlaceDetailsController {
    enum State: StateType {
        case `default`, saved(Place)
    }
    
    static func reducer(action: Action, state: State?) -> State {
        switch action {
        case let action as Success<Place>:
            return .saved(action.data)
        default:
            return .default
        }
    }
}

// MARK: - ActionCreators

private func addToFavorites(place: Place) -> (AppState, Store<AppState>) -> Action? {
    return { state, store in
        PlaceRepository.shared.addToFavorites(place).then {
            store.dispatch(Success(data: place))
            }.catch { error in
                store.dispatch(Failure(error: error))
        }
        
        let region = CLCircularRegion(center: place.coordinate, radius: 1000, identifier: place.name)
        NotificationService.scheduleLocationNotification(title: "Favorite place nearby", body: place.name, region: region)
        
        return Loading()
    }
}
