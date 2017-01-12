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
        case red = "red"
        case green = "green"
        case amber = "amber"
    }

    var currentState:State = .red
    
    
    init(state: State) {
        self.currentState = state
    }
}
