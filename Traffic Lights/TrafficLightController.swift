//
//  TrafficLightController.swift
//  Semaphore
//
//  Created by Nash on 11/1/17.
//  Copyright © 2017 Nash Trajkovski. All rights reserved.
//

import Foundation
import UIKit

//MARK - Globals
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
    static let AMBER_SEC = 25 // seconds
    
    let lightStates:LightDictionary = [LightDirection.NORTH:TrafficLight(state: .RED),
                                  LightDirection.SOUTH:TrafficLight(state: .RED),
                                  LightDirection.EAST:TrafficLight(state: .GREEN),
                                  LightDirection.WEST:TrafficLight(state: .GREEN)]
    

    
     func start() {
        //Fire once to set initial state.
        EventUtils.notify(notificationName: EventUtils.Notificatons.LIGHTS_CHANGED, payload: ["lights":self.lightStates])
        
        
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
    
    /* This method is the guts of the controller.
        It gets called once every 'tick' - in this instance it's once a second, but it can work once every 5 seconds if we want to reduce battery usage
        The idea is simple - keep track of the seconds elapsed (in the seconds variable) and increment +INTERVAL modulo MAX_TIME  (30 seconds)
        We check to see if we've hit our milestones (25 seconds, or 0 seconds) by '
        If we're at 25 seconds (AMBER_SEC), and the light is GREEN, then we switch it to AMBER 
        If we're back at 0 , then AMBER becomes RED, and RED becomes GREEN.
        In either 0 or 25 seconds, we publish a notification to all interested parties.
        
    */
    @objc func updateTrafficState(timer:Timer) {
        seconds = (seconds + TrafficLightController.INTERVAL) % TrafficLightController.MAX_TIME
         EventUtils.notify(notificationName: EventUtils.Notificatons.SECOND_TICKED, payload: ["seconds":self.seconds])
        if seconds == 0 {
            for light in self.lightStates.values {
                if light.currentState == .RED {
                    light.currentState = .GREEN
                }
                if light.currentState == .AMBER {
                    light.currentState = .RED
                }
            }
            
        } else if seconds == TrafficLightController.AMBER_SEC {
            for light in self.lightStates.values {
                if light.currentState == .GREEN {
                    light.currentState = .AMBER
                }
            }
        }
        
        if seconds == 0 || seconds == TrafficLightController.AMBER_SEC {
            EventUtils.notify(notificationName: EventUtils.Notificatons.LIGHTS_CHANGED, payload: ["lights":self.lightStates])
        }
    }
}
