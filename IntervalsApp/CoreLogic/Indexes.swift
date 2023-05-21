//
//  Indexes.swift
//  IntervalsApp
//
//  Created by Samuel Shally  on 7/11/21.
//

import SwiftUI
import CoreData
import NotificationCenter

class Indexes : ObservableObject
{
    @Published var background = "backgroundOne"
    @Published var taskIndex = 0
    @Published var taskValues = ["General"]
   
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(onUbiquitousKeyValueStoreDidChangeExternally(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
                
        //Update with 1.2.2 need to add new user default for background on start-up
        if(NewData.cloudDefaults.bool(forKey: "backSet") == false)
        {
            NewData.cloudDefaults.set(true, forKey: "backSet")
            NewData.cloudDefaults.set("backgroundOne", forKey: "background")
        }
        
        if(NewData.cloudDefaults.string(forKey: "background") != nil)
        {
            self.background = NewData.cloudDefaults.string(forKey: "background")!
        }
        
        //Update with 1.3 need to add new user default for current task on start up
        if(NewData.defaults.bool(forKey : "currentTaskSet") == false)
        {
            NewData.defaults.set("General", forKey: "currentTask")
            NewData.defaults.set(true, forKey : "currentTaskSet")
        }

    }
    
    @objc func onUbiquitousKeyValueStoreDidChangeExternally(notification:Notification)
    {
        //On Change of background externally
        
        if(NewData.cloudDefaults.string(forKey: "background") != nil)
        {
            self.background = NewData.cloudDefaults.string(forKey: "background")!
        }

    }
    
    
}
