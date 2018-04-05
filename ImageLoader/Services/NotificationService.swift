//
//  NotificationService.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/23/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

class NotificationService {
    
    static func registerForNotificationsIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
                    if let error = error {
                        print("Request Authorization Failed (\(error), \(error.localizedDescription))")
                    }
                    
                }
            case .authorized:
                break
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    static func scheduleLocationNotification(title: String, body: String, region: CLRegion) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        region.notifyOnEntry = true
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let request = UNNotificationRequest(identifier: "Favorite", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
        
    }
}
