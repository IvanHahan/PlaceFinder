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
    fileprivate var lastPosition: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStore()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
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
                marker.title = place.name
                marker.appearAnimation = .pop
                marker.map = mapView
            }
        case .location(let location):
            if needZoomToUser {
                mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14)
                needZoomToUser = false
            }
        case .loading:
            break
        }
        
    }
}

extension MapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if let coordinate = lastPosition {
            let delta = CLLocation(latitude: coordinate.latitude,
                                   longitude: coordinate.longitude).distance(from: CLLocation(latitude: position.target.latitude,
                                                                                              longitude: position.target.longitude))
            if delta.magnitude > 500 {
                store.dispatch(MapAction.loadPlaces(location: CLLocation(latitude: position.target.latitude, longitude: position.target.longitude),
                                                types: ["cafe", "pharmacy", "restaurant"]))
                lastPosition = position.target
            }
        } else {
            store.dispatch(MapAction.loadPlaces(location: CLLocation(latitude: position.target.latitude, longitude: position.target.longitude),
                                                types: ["cafe", "pharmacy", "restaurant"]))
            lastPosition = position.target
        }
    }
}
