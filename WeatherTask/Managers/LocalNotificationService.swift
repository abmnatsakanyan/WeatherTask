//
//  LocalNotificationService.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation
import UserNotifications

protocol LocalNotificationServiceable {
    func scheduleNotification(title: String, body: String)
}

final class LocalNotificationService: LocalNotificationServiceable {
    func scheduleNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
