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
    let imageMap = [TrafficLight.State.AMBER:UIImage(named: "amber"),
                    TrafficLight.State.RED:UIImage(named: "red"),
                    TrafficLight.State.GREEN:UIImage(named: "green")]
    
    //This probably should be a singleton.
    let trafficLightController = TrafficLightController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: EventUtils.Notificatons.LIGHTS_CHANGED), object: nil, queue:nil) { (notification) in
            //Lights have changed, so update each light based on
            let lights = notification.userInfo?["lights"] as! LightDictionary //Yeah this bit is a bit
            self.updateLightStates(lights )
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: EventUtils.Notificatons.SECOND_TICKED), object: nil, queue:nil)  { (notification) in
            if let secondValue:Int = notification.userInfo?["seconds"] as! Int? {
                self.secondCounter.text = "\(secondValue)"
            }
            
        }
        
    }
    
    @IBAction func startTrafficLights(_ sender: Any) {
        self.trafficLightController.start()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK- Logic
    func updateLightStates(_ lights:LightDictionary) {
        let northState = lights[LightDirection.NORTH]!.currentState
        northLight.image = imageMap[northState]!
        
        let southState = lights[LightDirection.SOUTH]!.currentState
        southLight.image = imageMap[southState]!
        
        let eastState = lights[LightDirection.EAST]!.currentState
        eastLight.image = imageMap[eastState]!
        
        let westState = lights[LightDirection.WEST]!.currentState
        westLight.image = imageMap[westState]!
        
    
    }
    



}
