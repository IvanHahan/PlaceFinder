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
    
    fileprivate var places: Set<Place> = Set()
    fileprivate var needZoomToUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStore()
        mapView.isMyLocationEnabled = true
    }
    
    fileprivate func setupStore() {
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
                guard !self.places.contains(place) else { continue }
                self.places.insert(place)
                let marker = GMSMarker(position: place.coordinate)
                marker.position = place.coordinate
                marker.title = place.name
                marker.appearAnimation = .pop
                marker.map = mapView
            }
        case .location(let location):
            if needZoomToUser {
                mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14)
                needZoomToUser = false
                store.dispatch(MapAction.loadPlaces(location: location, types: ["cafe", "pharmacy", "restaurant"]))
            }
        case .loading:
            break
        }
        
    }
}
