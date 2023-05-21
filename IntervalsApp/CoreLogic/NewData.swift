//
//  DataTest.swift
//  PracticeTwo
//
//  Created by Samuel Shally on 6/5/21.
//

import Foundation

struct NewData
{
    static let defaults = UserDefaults.standard
    static var cloudDefaults = NSUbiquitousKeyValueStore()
        
    static func createDefaults()
    {
       //Use ICloud
        cloudDefaults.set(true, forKey: "hasData")
        
        cloudDefaults.set(300, forKey: "interval")
        cloudDefaults.set(1, forKey: "pickerIndex")
        
        cloudDefaults.set(3, forKey: "targetIntervalsIndex")
        cloudDefaults.set(0, forKey: "highScore")
        
        //logic for background
        NewData.cloudDefaults.set(true, forKey: "backSet")
        cloudDefaults.set("backgroundOne", forKey: "background")
        
        
        //Stay UserDefaults
        defaults.set("General", forKey: "currentTask")
        defaults.set(true, forKey : "currentTaskSet")
                
        defaults.set("initial", forKey : "timerState")
        defaults.set(Date(), forKey: "endTime" )
        defaults.set(0.0, forKey: "secondsLeft")
        
        
    }
    
}

