//
//  FavoritesController.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/22/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import UIKit
import Kingfisher
import ReSwift
import Closures

class FavoritesController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.numberOfRows { [unowned self] _ in
                return self.places.count
            }.cellForRow { [unowned self] indexPath in
                let cell = self.tableView.dequeueReusableCell(resource: UITableViewCell.self, for: indexPath)
                cell.textLabel?.text = self.places[indexPath.row].name
                cell.detailTextLabel?.text = self.places[indexPath.row].address
                cell.imageView?.kf.setImage(with: self.places[indexPath.row].icon) { [unowned self] _, _, _, _ in
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                return cell
            }.didSelectRowAt { [unowned self] indexPath in
                self.performSegue(withIdentifier: "PlaceDetails", sender: self.places[indexPath.row])
            }.canEditRowAt {
                _ in return true
            }.commit { [unowned self] editingStyle, indexPath in
                switch editingStyle {
                case .delete:
                    store.dispatch(removeFromFavorite(place: self.places[indexPath.row]))
                default:()
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.favoritesState
            }
        }
        store.dispatch(loadFavorites)
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

extension FavoritesController: StoreSubscriber {
    func newState(state: State) {
        switch state {
        case .favorites(let places):
            self.places = places
            tableView.reloadData()
        case .remove(let place):
            guard let index = places.index(of: place) else { return }
            places.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        default: ()
        }
    }
}

// MARK: - RE

extension FavoritesController {
    
    // MARK: - State
    
    enum State: StateType {
        case `default`, favorites([Place]), remove(Place)
    }
    
    // MARK: - Reducer
    
    static func reducer(action: Action, state: State?) -> State {
        switch action {
        case let action as SetFavorites:
            return .favorites(action.places)
        case let action as RemoveFavorite:
            return .remove(action.place)
        default:
            return .default
        }
    }
    
}

// MARK: - Actions

private struct RemoveFavorite: Action { let place: Place }
private struct SetFavorites: Action { let places: [Place] }

// MARK: - ActionCreators

private func removeFromFavorite(place: Place) -> (AppState, Store<AppState>) -> Action? {
    return { state, store in
        PlaceRepository.shared.removeFavorite(place: place).then { (place) in
            store.dispatch(RemoveFavorite(place: place))
        }
        return Loading()
    }
}

private func loadFavorites(state: AppState, store: Store<AppState>) -> Action? {
    PlaceRepository.shared.loadFavorites().then { places in
        store.dispatch(SetFavorites(places: places))
    }
    return Loading()
}
