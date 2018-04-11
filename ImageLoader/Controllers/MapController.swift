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
import UserNotifications

class MapController: UIViewController {
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    fileprivate var places: Set<Place> = Set()
    fileprivate var needZoomToUser = true
    fileprivate var lastPosition: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.mapState
            }
        }
        store.dispatch(startListeningLocation)
        store.dispatch(registerForNotificationsIfNeeded)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? PlaceDetailsController, let place = sender as? Place {
            vc.place = place
        }
    }
}

// MARK: - StoreSubscriber

extension MapController: StoreSubscriber {
    
    func newState(state: State) {
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
                mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                needZoomToUser = false
            }
        case .loading:
            break
        }
        
    }
}

// MARK: - GMSMapViewDelegate

extension MapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        guard let coordinate = lastPosition else {
            loadPlacesNearby(at: position.target)
            return
        }
        let delta = CLLocation(latitude: coordinate.latitude,
                               longitude: coordinate.longitude).distance(from: CLLocation(latitude: position.target.latitude,
                                                                                          longitude: position.target.longitude))
        if delta.magnitude > 500 {
            loadPlacesNearby(at: position.target)
        }
    }
    
    private func loadPlacesNearby(at coord: CLLocationCoordinate2D) {
        store.dispatch(loadPlaces(location: CLLocation(latitude: coord.latitude, longitude: coord.longitude),
                                            types: ["cafe", "pharmacy", "restaurant"]))
        lastPosition = coord
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let marker = marker as? MapMarker else { return }
        let place = places.first(where: { marker.id == $0.id })
        performSegue(withIdentifier: "PlaceDetails", sender: place)
    }
}

// MARK: - RE

extension MapController {
    
    enum State: StateType {
        case places([Place])
        case location(CLLocation)
        case loading
    }
    
    static func reducer(action: Action, state: State?) -> State {
        switch action {
        case let action as UpdatePlaces:
            return .places(action.places)
        case let action as UpdateLocation:
            return .location(action.location)
        default:
            return state ?? .places([])
        }
    }
}

// MARK: - Actions

private struct UpdateLocation: Action { let location: CLLocation }

private struct UpdatePlaces: Action { let places: [Place] }

// MARK: - ActionCreators

private func requestLocationAuthorization(state: AppState, store: Store<AppState>) -> Action {
    if !LocationService.shared.isAuthorized {
        LocationService.shared.requestAuthorization()
    }
    return Dumb()
}

private func startListeningLocation(state: AppState, store: Store<AppState>) -> Action? {
    LocationService.shared.startObservingLocation { location in
        store.dispatch(UpdateLocation(location: location))
    }
    return LocationService.shared.currentLocation == nil ? Dumb() : UpdateLocation(location: LocationService.shared.currentLocation!)
}

private func loadPlaces(location: CLLocation, types: [String], radius: Int = 500) -> (AppState, Store<AppState>) -> Action? {
    return { state, store in
        PlaceRepository.shared.loadPlaces(types: types, location: location.coordinate, radius: radius).then({ places in
            store.dispatch(UpdatePlaces(places: places))
        }).catch { error in
            store.dispatch(Failure(error: error))
        }
        return Loading()
    }
}

private func registerForNotificationsIfNeeded(state: AppState, store: Store<AppState>) -> Action? {
    NotificationService.registerForNotificationsIfNeeded()
    return Dumb()
}

