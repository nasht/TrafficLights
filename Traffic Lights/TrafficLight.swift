//
//  TrafficLight.swift
//  Semaphore
//
//  Created by Nash on 11/1/17.
//  Copyright © 2017 Nash Trajkovski. All rights reserved.
//

import Foundation

class TrafficLight  : AnyObject  {
    
    enum State : String {
        case RED = "red"
        case GREEN = "green"
        case AMBER = "amber"
    }
    
    //Could use getter and setter extensions here if we want ot make this a less "Dumb" object
    var currentState:State = .RED
    
    
    init(state: State) {
        self.currentState = state
    }
    
    
    
}
