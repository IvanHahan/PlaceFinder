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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? PlaceDetailsController, let place = sender as? Place {
            vc.place = place
        }
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
                let marker = MapMarker(position: place.coordinate)
                marker.title = place.name
                marker.appearAnimation = .pop
                marker.map = mapView
                marker.id = place.id
                URLSession.shared.dataTask(with: place.icon, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.global().async {
                        if let image = UIImage(data: data!) {
                            DispatchQueue.main.async {
                                marker.icon = image
                            }
                        }
                    }
                }).resume()
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
        guard let coordinate = lastPosition else {
            loadPlaces(at: position.target)
            return
        }
        let delta = CLLocation(latitude: coordinate.latitude,
                               longitude: coordinate.longitude).distance(from: CLLocation(latitude: position.target.latitude,
                                                                                          longitude: position.target.longitude))
        if delta.magnitude > 500 {
            loadPlaces(at: position.target)
        }
    }
    
    private func loadPlaces(at coord: CLLocationCoordinate2D) {
        store.dispatch(MapAction.loadPlaces(location: CLLocation(latitude: coord.latitude, longitude: coord.longitude),
                                            types: ["cafe", "pharmacy", "restaurant"]))
        lastPosition = coord
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let marker = marker as? MapMarker else { return }
        let place = places.first(where: { marker.id == $0.id })
        performSegue(withIdentifier: "PlaceDetails", sender: place)
    }
}
