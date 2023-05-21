//
//  DataBuild.swift
//  IntervalsApp
//
//  Created by Samuel Shally  on 7/13/21.
//

import Foundation
import SwiftUI
import CoreData
import Charts


class DataBuild : ObservableObject
{
    
    let viewContext: NSManagedObjectContext =  PersistenceController.shared.container.viewContext

    let itemRequest = NSFetchRequest<Item>(entityName: "Item")
 
    let taskRequest = NSFetchRequest<Task>(entityName: "Task")
    
    @Published var targetIntervals = 0
    @Published var highScore = 0
    
    @Published var yearData = [("",0)]
    @Published var monthData = [("",0)]
    @Published var lastSevenData = [("",0)]
    @Published var todayData = [("",0)]
    
    @Published var yearIntervals = 0
    @Published var monthIntervals = 0
    @Published var lastSevenIntervals = 0
    @Published var intervalsToday = 0
    @Published var allTimeIntervals = 0
    
    @Published var timeToday = ""
    @Published var timeLastSeven = ""
    @Published var timeThisMonth = ""
    @Published var timeThisYear = ""
    
    func update()
    {
        getTargetIntervals()
        getHighScore()
        
        refreshIntervals()
        
        getTimeToday()
        getTimeLastSeven()
        getTimeThisMonth()
        getTimeThisYear()
        
    }
    
    func getTargetIntervals()
    {
        
        guard
            let tasks = try? viewContext.fetch(taskRequest)
        else
        {
            return
        }
           
        let currentTask = NewData.defaults.string(forKey: "currentTask")
    
        if(currentTask == "General")
        {
            self.targetIntervals = Int(NewData.cloudDefaults.double(forKey: "targetIntervalsIndex"))
        }
        else
        {
            for task in tasks
            {
                if(task.name == currentTask)
                {
                    self.targetIntervals = Int(task.target)
                }
            }
        }
        
    }
    
    func getHighScore() -> Void
    {
        guard
            let tasks =  try? viewContext.fetch(taskRequest)
        else
        {
            return
        }
        
        let currentTask = NewData.defaults.string(forKey: "currentTask")
        
        if(currentTask == "General")
        {
            self.highScore = Int(NewData.cloudDefaults.double(forKey: "highScore"))
        }
        else
        {
            for task in tasks
            {
                if(task.name == currentTask)
                {
                    self.highScore = Int(task.score)
                }
            }
            
        }
        
    }
    
    func refreshIntervals() -> Void
    {
        guard
            let tasks =  try? viewContext.fetch(taskRequest)
        else
        {
            return
        }
        
        guard
            let items = try? viewContext.fetch(itemRequest)
        else
        {
            return
        }
        
        let currentTask = NewData.defaults.string(forKey: "currentTask")
        
        if(currentTask == "General")
        {
            var newDates : [Date] = []
            
            for x in items
            {
                if(x.timestamp != nil)
                {
                    newDates.append(x.timestamp!)
                }
            }
            
            self.yearData = GraphData.yearData(newDates)
            self.monthData = GraphData.getMonthData(newDates)
            self.lastSevenData = GraphData.getLastSeven(newDates)
            self.todayData = GraphData.todayData(newDates)
            
            self.yearIntervals = GraphData.intervalsThisYear(newDates)
            self.monthIntervals = GraphData.intervalsThisMonth(newDates)
            self.lastSevenIntervals = GraphData.intervalsLastSeven(newDates)
            self.intervalsToday = GraphData.intervalsToday(newDates)
            self.allTimeIntervals = newDates.count

        }
        
        else
        {
            for task in tasks
            {
                if(task.name == currentTask)
                {
                    if(task.entry != nil)
                    {
                        if(task.entry!.count > 0)
                        {
                            var newDates : [Date] = []
                            
                            for entry in task.entry!
                            {
                                guard
                                    let entry : Entry = entry as? Entry
                                else
                                {
                                    continue
                                }
                                
                               guard
                                   let date = entry.timestamp
                                else
                               {
                                    continue
                               }
                                
                                newDates.append(date)
                            }
                            
                            self.yearData = GraphData.yearData(newDates)
                            self.monthData = GraphData.getMonthData(newDates)
                            self.lastSevenData = GraphData.getLastSeven(newDates)
                            self.todayData = GraphData.todayData(newDates)
                            
                            self.yearIntervals = GraphData.intervalsThisYear(newDates)
                            self.monthIntervals = GraphData.intervalsThisMonth(newDates)
                            self.lastSevenIntervals = GraphData.intervalsLastSeven(newDates)
                            self.intervalsToday = GraphData.intervalsToday(newDates)
                            self.allTimeIntervals = newDates.count
                        }
                        else
                        {
                            fillData()
                        }
                    }
                    else
                    {
                        fillData()
                    }
                }
            }
        }
    }
    
    func fillData()
    {
            self.yearData = GraphData.yearData([])
            self.monthData = GraphData.getMonthData([])
            self.lastSevenData = GraphData.getLastSeven([])
            self.todayData = GraphData.todayData([])
            
            self.yearIntervals = GraphData.intervalsThisYear([])
            self.monthIntervals = GraphData.intervalsThisMonth([])
            self.lastSevenIntervals = GraphData.intervalsLastSeven([])
            self.intervalsToday = GraphData.intervalsToday([])
            self.allTimeIntervals = 0
        
    }
    
    func getTimeToday() -> Void
    {
        let currentTask = NewData.defaults.string(forKey: "currentTask")
        var totalTime = 0.0
        
        guard
            let tasks =  try? viewContext.fetch(taskRequest)
        else
        {
            return
        }
        
        guard
            let items = try? viewContext.fetch(itemRequest)
        else
        {
            return
        }
        
        func beginningOfTheDay(_ current : Date) -> Date
        {
            return Calendar.current.date(from:
                    Calendar.current.dateComponents([.year,.month,.day], from: current))!
        }

        func nextDay() -> Date
        {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            
            return tomorrow
        }
        
        let today = beginningOfTheDay(Date())
        let tomorrow = beginningOfTheDay(nextDay())
        
        if(currentTask == "General")
        {
            for item in items
            {
                guard
                    let date = item.timestamp
                else
                {
                    continue
                }
                
                if(date >= today && date < tomorrow)
                {
                    totalTime += item.length
                }
 
            }
            
        }
        else
        {
            for task in tasks
            {
                if(task.name == currentTask)
                {
                    if(task.entry != nil)
                    {
                        for entry in task.entry!
                        {
                            guard
                                let entry : Entry = entry as? Entry
                            else
                            {
                                continue
                            }
                            
                           guard
                               let date = entry.timestamp
                            else
                           {
                                continue
                           }
                            
                            if(date >= today && date < tomorrow)
                            {
                                totalTime += entry.length
                            }
                        }
                    }
                }
            }
        }
        
        self.timeToday = timeString(totalTime)
    }
    
    
    func getTimeLastSeven()
    {
        let currentTask = NewData.defaults.string(forKey: "currentTask")
        var totalTime = 0.0
        
        guard
            let tasks =  try? viewContext.fetch(taskRequest)
        else
        {
            return
        }
        
        guard
            let items = try? viewContext.fetch(itemRequest)
        else
        {
            return
        }
        
        func getNewDate(_ val : Int, _ date : Date) -> Date
        {
            let trial = Calendar.current.date(byAdding: .day, value: val, to: date)
            
            return trial!
        }

        func beginningOfTheDay(_ current : Date) -> Date
        {
            return Calendar.current.date(from:
                    Calendar.current.dateComponents([.year,.month,.day], from: current))!
        }
        
        
        let startToday = beginningOfTheDay(Date())
        let startSeven = getNewDate(-6,startToday)
        
        
        if(currentTask == "General")
        {
            for item in items
            {
                guard
                    let date = item.timestamp
                else
                {
                    continue
                }

                if(date >= startSeven)
                {
                    totalTime += item.length
                }
            }
        }
        else
        {
            for task in tasks
            {
                if(task.name == currentTask)
                {
                    if(task.entry != nil)
                    {
                        for entry in task.entry!
                        {
                            guard
                                let entry : Entry = entry as? Entry
                            else
                            {
                                continue
                            }
                            
                           guard
                               let date = entry.timestamp
                            else
                           {
                                continue
                           }
                            
                            if(date >= startSeven)
                            {
                                totalTime += entry.length
                            }
                        }
                    }
                }
            }
        }
        
        self.timeLastSeven = timeString(totalTime)
    }
    
    func getTimeThisMonth()
    {
        let currentTask = NewData.defaults.string(forKey: "currentTask")
        var totalTime = 0.0
        
        guard
            let tasks =  try? viewContext.fetch(taskRequest)
        else
        {
            return
        }
        
        guard
            let items = try? viewContext.fetch(itemRequest)
        else
        {
            return
        }
        
        func firstDayOfTheMonth(_ current : Date) -> Date
        {
                    return Calendar.current.date(from:
                            Calendar.current.dateComponents([.year,.month], from: current))!
        }
        
        let firstDay = firstDayOfTheMonth(Date())
        
        if(currentTask == "General")
        {
            for item in items
            {
                guard
                    let date = item.timestamp
                else
                {
                    continue
                }

                if(date >= firstDay)
                {
                    totalTime += item.length
                }
            }
        }
        else
        {
            for task in tasks
            {
                if(task.name == currentTask)
                {
                    if(task.entry != nil)
                    {
                        for entry in task.entry!
                        {
                            guard
                                let entry : Entry = entry as? Entry
                            else
                            {
                                continue
                            }
                            
                           guard
                               let date = entry.timestamp
                            else
                           {
                                continue
                           }
                            
                            if(date >= firstDay)
                            {
                                totalTime += entry.length
                            }
                        }
                    }
                }
            }
        }
        self.timeThisMonth = timeString(totalTime)
    }
    
    func getTimeThisYear()
    {
        let currentTask = NewData.defaults.string(forKey: "currentTask")
        var totalTime = 0.0
        
        guard
            let tasks =  try? viewContext.fetch(taskRequest)
        else
        {
            return
        }
        
        guard
            let items = try? viewContext.fetch(itemRequest)
        else
        {
            return
        }
        
        func firstDayOfTheYear(_ current : Date) -> Date
        {
                    return Calendar.current.date(from:
                            Calendar.current.dateComponents([.year], from: current))!
        }
        
        let firstDay = firstDayOfTheYear(Date())
        
        if(currentTask == "General")
        {
            for item in items
            {
                guard
                    let date = item.timestamp
                else
                {
                    continue
                }

                if(date >= firstDay)
                {
                    totalTime += item.length
                }
            }
        }
        else
        {
            for task in tasks
            {
                if(task.name == currentTask)
                {
                    if(task.entry != nil)
                    {
                        for entry in task.entry!
                        {
                            guard
                                let entry : Entry = entry as? Entry
                            else
                            {
                                continue
                            }
                            
                           guard
                               let date = entry.timestamp
                            else
                           {
                                continue
                           }
                            
                            if(date >= firstDay)
                            {
                                totalTime += entry.length
                            }
                        }
                    }
                }
            }
        }
        
        self.timeThisYear = timeString(totalTime)
    }
    
    func timeString(_ accumulatedTime: TimeInterval) -> String
    {

        let hours = Int(accumulatedTime) / 3600
       
        let minutes = Int(accumulatedTime) / 60 % 60
        
        
        let seconds = Int(accumulatedTime) % 60

        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}



//func updateLastSeven() -> Void
//{
//    DispatchQueue.global(qos: .userInteractive).async
//    {
////           must call viewContext on same thread?
////           https://developer.apple.com/documentation/coredata/using_core_data_in_the_background
//
//        DispatchQueue.main.async
//        {
//            //update UI Component here
//        }
//
//    }
//
//}
