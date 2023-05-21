//
//  TimerManager.swift
//  PracticeTwo
//
//  Created by Samuel Shally on 6/8/21.
//

import Foundation
import SwiftUI
import UserNotifications
import CoreData

class TimerManager : ObservableObject
{
    
    @Published var timerMode: TimerMode = .initial
    
    @Published var secondsLeft : Double = 1
    
    @Published var graphic : Double = 1
    
    @Published var timerLength : Double = 1
    
    @Published var endTime = Date()
    
    @Published var isDone = false
    
    var timer = Timer()
    
    
    func start()
    {
        timerMode = .running
        NewData.defaults.set("running" , forKey: "timerState")
        
        endTime = Date().addingTimeInterval(secondsLeft)
        NewData.defaults.set(endTime, forKey: "endTime")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block:
            {
                timer in
                
                if (self.secondsLeft <= 0)
                {
                    self.reset()
                    self.isDone = true
                }
                
                self.secondsLeft -= 1
                
                self.graphic = self.secondsLeft/self.timerLength
        
            })
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                                            
    }
    
    func reset()
    {
        timer.invalidate()
        self.timerMode = .initial
        
        NewData.defaults.set("initial", forKey : "timerState")
    }
        
    func fromBackground()
    {
        self.secondsLeft = endTime.timeIntervalSince(Date())
    }
    
    func appRestartRunning()
    {
        let retrivedEndTime = UserDefaults.standard.value(forKey: "endTime") as! Date
        self.secondsLeft = retrivedEndTime.timeIntervalSince(Date())
        start()
        
    }
    
    func appRestartPaused()
    {
        self.secondsLeft = NewData.defaults.double(forKey: "secondsLeft")
        self.timerMode = .paused
    }
    
    func pause()
    {
        timer.invalidate()
        self.timerMode = .paused
        
        NewData.defaults.set(self.secondsLeft, forKey: "secondsLeft")
        NewData.defaults.set("paused", forKey : "timerState")
    }
    
    
    
}
