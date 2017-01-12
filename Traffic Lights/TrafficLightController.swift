//
//  TrafficLightController.swift
//  Semaphore
//
//  Created by Nash on 11/1/17.
//  Copyright © 2017 Nash Trajkovski. All rights reserved.
//

import Foundation
import UIKit

//MARK:  - Globals
typealias LightDictionary = [LightDirection:TrafficLight]

enum LightDirection:Int {
    case north
    case south
    case east
    case west
}

//MARK: -
class TrafficLightController : AnyObject{
    
    //Lets make this flexible to speed up testing.
    var maxTime:Int = 30 //seconds
    var tick:Int = 1 //seconds
    var amberSec = 25 // seconds
    
    let lightStates:LightDictionary =
                                 [LightDirection.north:TrafficLight(state: .red),
                                  LightDirection.south:TrafficLight(state: .red),
                                  LightDirection.east:TrafficLight(state: .green),
                                  LightDirection.west:TrafficLight(state: .green)]
    

    private var _controllerRunning : Bool = false
    
    var timer:Timer?
    
    var isRunning : Bool {
        get {
            return _controllerRunning
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil //and hopefully GC will do its job here.
        self._controllerRunning = false
        
    }
    
    func reset() {
        self.stop()
        self.seconds = 0
        
    }
     func start() {
       
   
        
        //Check controller state matters!
        if (self._controllerRunning) {
            return
        }
        
        //Fire once to set initial state.
        EventUtils.notify(notificationName: EventUtils.Notificatons.LIGHTS_CHANGED, payload: [EventUtils.payloadKeyFor(notification: EventUtils.Notificatons.LIGHTS_CHANGED):self.lightStates])
        
        
        //Check light status every INTERVAL seconds
        if #available(iOS 10.0, *) {
            self.timer  = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.tick), repeats: true) { (timer) in
                self.updateTrafficState(timer: timer)
            }
        } else {
            // Fallback on earlier versions
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.tick), target: self, selector:  #selector(self.updateTrafficState(timer:)), userInfo: nil, repeats: true)
        }
        
         self._controllerRunning = true
        
        
    }
    
 
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
        seconds = (seconds + tick) % maxTime
         EventUtils.notify(notificationName: EventUtils.Notificatons.SECOND_TICKED,
                           payload: [EventUtils.payloadKeyFor(notification: EventUtils.Notificatons.SECOND_TICKED):self.seconds])
        
        if seconds == 0 {
            for light in self.lightStates.values {
                if light.currentState == .red {
                    light.currentState = .green
                }
                if light.currentState == .amber {
                    light.currentState = .red
                }
            }
            
        } else if seconds == amberSec {
            for light in self.lightStates.values {
                if light.currentState == .green {
                    light.currentState = .amber
                }
            }
        }
        
        if seconds == 0 || seconds == amberSec {
            EventUtils.notify(notificationName: EventUtils.Notificatons.LIGHTS_CHANGED,
                              payload: [EventUtils.payloadKeyFor(notification: EventUtils.Notificatons.LIGHTS_CHANGED):self.lightStates])
        }
    }
}
