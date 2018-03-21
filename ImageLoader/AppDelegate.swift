//
//  AppDelegate.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/10/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import ReSwift

let store = Store<AppState>(reducer: appReducer, state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let container: NSPersistentContainer = NSPersistentContainer(name: "Places")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        container.loadPersistentStores { (_, error) in
            guard error == nil else { fatalError() }
            let sessionManager = SessionManager(baseUrl: GooglePlacesBaseUrl, config: .default)
            PlaceRepository.shared = PlaceRepository(sessionManager: sessionManager, context: self.container.newBackgroundContext())
        }
        GMSServices.provideAPIKey("AIzaSyAybTrBW7gYiFksaYyv3_K11-4Q6JHXsDk")
        return true
    }
}

