//
//  TrafficLightController.swift
//  Semaphore
//
//  Created by Nash on 11/1/17.
//  Copyright © 2017 Nash Trajkovski. All rights reserved.
//

import Foundation
import UIKit

//Expose this globally.
typealias LightDictionary = [LightDirection:TrafficLight]

enum LightDirection:Int {
    case NORTH
    case SOUTH
    case EAST
    case WEST
}

class TrafficLightController : AnyObject{
    
    
    

    
    static let MAX_TIME:Int = 30 //seconds
    static let INTERVAL:Int = 1 //seconds

    
    let lights:LightDictionary = [LightDirection.NORTH:TrafficLight(state: .RED),
                                  LightDirection.SOUTH:TrafficLight(state: .RED),
                                  LightDirection.EAST:TrafficLight(state: .GREEN),
                                  LightDirection.WEST:TrafficLight(state: .GREEN)]
    

    
     func start() {
        //Fire once to set initial state.
        EventUtils.notify(notificationName: EventUtils.Notificatons.LIGHTS_CHANGED, payload: ["lights":self.lights])
        
        
        //Check light status every INTERVAL seconds
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(TrafficLightController.INTERVAL), repeats: true) { (timer) in
                self.updateTrafficState(timer: timer)
            }
        } else {
            // Fallback on earlier versions
            _ = Timer.scheduledTimer(timeInterval: TimeInterval(TrafficLightController.INTERVAL), target: self, selector:  #selector(updateTrafficState(timer:)), userInfo: nil, repeats: true)
        }
        
        
    }
    
    //Had to move seconds here to support pre ios 10 devices
    var seconds:Int = 0
    
    @objc func updateTrafficState(timer:Timer) {
        seconds = (seconds + TrafficLightController.INTERVAL) % TrafficLightController.MAX_TIME
         EventUtils.notify(notificationName: EventUtils.Notificatons.SECOND_TICKED, payload: ["seconds":self.seconds])
        if seconds == 0 {
            for light in self.lights.values {
                if light.currentState == .RED {
                    light.currentState = .GREEN
                }
                if light.currentState == .AMBER {
                    light.currentState = .RED
                }
            }
            
        } else if seconds == 25 {
            for light in self.lights.values {
                if light.currentState == .GREEN {
                    light.currentState = .AMBER
                }
            }
        }
        
        if seconds == 0 || seconds == 25 {
            EventUtils.notify(notificationName: EventUtils.Notificatons.LIGHTS_CHANGED, payload: ["lights":self.lights])
        }
    }
    

}
