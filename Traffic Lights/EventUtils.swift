//
//  EventUtils.swift
//  Traffic Lights
//
//  Created by Nash on 11/1/17.
//
//

import Foundation

class EventUtils {
    
    struct Notificatons {
        static let LIGHTS_CHANGED = "lightsChangedNotification"
        static let SECOND_TICKED  = "secondTickedNotification"
    }
    
    
    class func notify(notificationName:String, payload:[AnyHashable:Any]) {
        DispatchQueue.main.async {
            let notification = Notification(name: Notification.Name(rawValue: notificationName), object: nil, userInfo: payload)
            NotificationCenter.default.post(notification)
        }
    }
}
