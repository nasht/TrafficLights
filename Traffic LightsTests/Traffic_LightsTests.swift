//
//  Traffic_LightsTests.swift
//  Traffic LightsTests
//

import XCTest
@testable import Traffic_Lights

class Traffic_LightsTests: XCTestCase {
    
    var lightController = TrafficLightController()

    
    override func setUp() {
        super.setUp()
        lightController.maxTime = 5
        lightController.tick = 1
        lightController.amberSec = 3
        lightController.start()
    }
    
    override func tearDown() {
        lightController.reset()
        super.tearDown()
    }
    
    func testNorthEastInequality() {
        let lightStates = lightController.lightStates
        let northLight = lightStates[LightDirection.north]
        let eastLight = lightStates[LightDirection.east]
        
        XCTAssert(northLight?.currentState != eastLight?.currentState)
        
    }
    
    func testNorthSouthEquality() {
        let lightStates = lightController.lightStates
        let northLight = lightStates[LightDirection.north]
        let southLight = lightStates[LightDirection.south]
        XCTAssert(northLight?.currentState == southLight?.currentState)
    }
    
    //TODO: Test that the lights turn from green to Amber before going to red. This will involve XCTestExpectation, but I've not worked with it in the past and time is limited. Keeping below method to show what I tried and what didn't work :(
//    
//    func testGreenToAmber() {
//        let lightStates = lightController.lightStates
//        let greenLights = lightStates.values.filter { (value: TrafficLight) -> Bool in
//            if value.currentState == TrafficLight.State.green {
//                return true
//            }
//            return false
//        }
//        
//        
//        while lightController.seconds < lightController.amberSec {
//            print(lightController.seconds)
//            Thread.sleep(forTimeInterval: TimeInterval(1))
//        }
//
//        for light in greenLights {
//            XCTAssert(light.currentState == TrafficLight.State.amber)
//        }
//    
//    
//    }

    
}
