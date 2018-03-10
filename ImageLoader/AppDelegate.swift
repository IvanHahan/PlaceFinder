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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyAybTrBW7gYiFksaYyv3_K11-4Q6JHXsDk")
        return true
    }
}

