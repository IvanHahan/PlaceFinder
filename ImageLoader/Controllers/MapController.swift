//
//  MapController.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/10/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import UIKit
import ReSwift
import GoogleMaps

class MapController: UIViewController {
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    fileprivate var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        store.subscribe(self) {
            $0.select {
                $0.mapState
            }
        }
        store.dispatch(MapAction.requestLocationAuthorization)
        store.dispatch(MapAction.startListeningLocation)
    }

}

extension MapController: StoreSubscriber {
    
    func newState(state: MapState) {
        switch state {
        case .places(let places):
            for place in places {
                let marker = GMSMarker(position: place.coordinate)
                marker.title = place.name
                marker.map = mapView
            }
            self.places.append(contentsOf: places)
        case .location(let location):
            store.dispatch(MapAction.loadPlaces(location: location, types: []))
        case .loading:
            break
        }
        
    }
}
