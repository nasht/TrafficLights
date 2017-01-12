//
//  TrafficLightViewController.swift
//  Traffic Lights
//
//  Created by Nash on 11/1/17.
//
//

import Foundation
import UIKit

class TrafficLightViewController : UIViewController {
    
    
    @IBOutlet weak var northLight: UIImageView!
    @IBOutlet weak var eastLight: UIImageView!
    @IBOutlet weak var westLight: UIImageView!
    @IBOutlet weak var southLight: UIImageView!
    
    @IBOutlet weak var secondCounter: UILabel!
    let imageMap = [TrafficLight.State.amber:UIImage(named: "amber"),
                    TrafficLight.State.red:UIImage(named: "red"),
                    TrafficLight.State.green:UIImage(named: "green")]
    
    //This will allow us to map the lightState to the view elements without too much duplication
    var lightMap : [LightDirection:UIImageView]?
    
    //This probably should be a singleton, but I'm leaving for later optimisation
    var trafficLightController = TrafficLightController()
    
  

    
    //MARK: - configuration methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewHelpers()
        self.configureLightController()
        self.configureEventListeners()
        
    }
    
    func configureViewHelpers() {
        self.lightMap =
            [LightDirection.north:northLight,
             LightDirection.south:southLight,
             LightDirection.east:eastLight,
             LightDirection.west:westLight]
    }
    func configureLightController() {
        //Configure the light settings
        trafficLightController.maxTime = 30
        trafficLightController.tick = 1
        trafficLightController.amberSec = 25
    }
    func configureEventListeners() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: EventUtils.Notificatons.LIGHTS_CHANGED),
                                               object: nil,
                                               queue:nil) { (notification) in
            //Lights have changed, so update each lightView
            let lights = notification.userInfo?[EventUtils.payloadKeyFor(notification: EventUtils.Notificatons.LIGHTS_CHANGED)] as! LightDictionary
            self.updateLightStates(lights )
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: EventUtils.Notificatons.SECOND_TICKED),
                                               object: nil,
                                               queue:nil)  { (notification) in
            if let secondValue:Int = notification.userInfo?[EventUtils.payloadKeyFor(notification: EventUtils.Notificatons.SECOND_TICKED)] as! Int? {
                self.secondCounter.text = "\(secondValue)"
            }
            
        }
    }
    
    @IBAction func toggleTrafficLights(_ sender: UIButton) {
        if (!self.trafficLightController.isRunning) {
            self.trafficLightController.start()
            //TODO: Move this text to a NSLocalisedString
            sender.setTitle("stop", for: UIControlState.normal)
        }else {
            self.trafficLightController.stop()
            sender.setTitle("start", for: UIControlState.normal)
        }

        
    }
    
    
    //MARK: - Logic
    func updateLightStates(_ lights:LightDictionary) {
        
        for (direction, light) in lights {
            if let lightImage = self.lightMap?[direction] {
                if let image = imageMap[light.currentState] {
                    lightImage.image = image
                } else {
                    debugPrint("image asset not found for \(light.currentState)")
                }
            } else {
                debugPrint("UIView not found for \(direction)")
            }
        }
    
    }
    
   



}
