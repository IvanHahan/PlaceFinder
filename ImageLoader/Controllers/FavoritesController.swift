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

class FavoritesController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        store.subscribe(self) {
            $0.select {
                $0.favoritesState
            }
        }
        
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.dispatch(loadFavorites)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? PlaceDetailsController, let place = sender as? Place {
            vc.place = place
        }
    }
}

extension FavoritesController: StoreSubscriber {
    func newState(state: FavoritesState) {
        switch state {
        case .favorites(let places):
            self.places = places
            tableView.reloadData()
        }
    }
}

extension FavoritesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(resource: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        cell.detailTextLabel?.text = places[indexPath.row].address
        cell.imageView?.kf.setImage(with: places[indexPath.row].icon)
        return cell
    }
}

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PlaceDetails", sender: places[indexPath.row])
    }
}
