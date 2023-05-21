//
//  GraphData.swift
//  PracticeTwo
//
//  Created by Samuel Shally on 6/13/21.
//

import Foundation
import CoreData
import SwiftUI


struct GraphData
{
    
    static func yearData(_ newDates : [Date]) -> [(String, Int)]
    {
        
        //Algorithm for getting intervals by month

        func firstDayOfTheYear(_ current : Date) -> Date
        {
                    return Calendar.current.date(from:
                            Calendar.current.dateComponents([.year], from: current))!
        }

        func getSomeMonthFromFirst(_ val : Int) -> Date
        {
            let firstDay = firstDayOfTheYear(Date())
            
            let nextMonth = Calendar.current.date(byAdding: .month, value: val, to: firstDay)
            
            return nextMonth!
        }

        var current = 0

        let month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

        var parsedYear : [(String , Int)] = []

        while(current < 12)
        {
            let month = month[current]
            var count = 0
            let next = current + 1
            
            let fd = getSomeMonthFromFirst(current)
            let nm = getSomeMonthFromFirst(next)
            
            for x in newDates
            {
                if(x >= fd && x<nm )
                {
                    count += 1
                }
                
                
            }
            
            current += 1
            parsedYear.append((month,count))
            
        }

        return parsedYear
    }
    
    static func getMonthData(_ newDates : [Date]) -> [(String, Int)]
    {
       
        //Algorith for getting data by day in month
            
        func firstDayOfTheMonth(_ current : Date) -> Date
        {
                    return Calendar.current.date(from:
                            Calendar.current.dateComponents([.year,.month], from: current))!
        }

        func getSomeMonthFromDate(_ val : Int, _ date : Date) -> Date
        {
                
            let month = Calendar.current.date(byAdding: .month, value: val, to: date)
            
            return month!
        }

        func getNextDay(_ date : Date) -> Date
        {
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
            
            return nextDay!
        }

        let thisMonth = firstDayOfTheMonth(Date())
        let nextMonth = getSomeMonthFromDate(1, thisMonth)


        var allThisMonth : [Date] = []

        for x in newDates
        {
            if(x >= thisMonth && x < nextMonth)
            {
                allThisMonth.append(x)
            }
        }

        var dayInMonth = thisMonth
        var parsedMonth : [(String , Int)] = []

        while(dayInMonth < nextMonth)
        {
            var count = 0
            let nextDay = getNextDay(dayInMonth)
            
            for x in allThisMonth
            {
                if(x >= dayInMonth && x < nextDay)
                {
                    count += 1
                }
                
            }
            
            let calanderDate = Calendar.current.dateComponents([.day, .month], from: dayInMonth)
            let month = calanderDate.month!
            let day = calanderDate.day!
            let str = "\(month)/\(day)"
            

            parsedMonth.append((str, count))
            
            dayInMonth = nextDay
        }
        
        return parsedMonth
    }
    
   static func getLastSeven(_ newDates : [Date]) -> [(String, Int)]
    {
        
        //Algorithm for getting data for last seven days

        func getNewDate(_ val : Int, _ date : Date) -> Date
        {
            let trial = Calendar.current.date(byAdding: .day, value: val, to: date)
            
            return trial!
        }

        func getNewDate(_ val : Int) -> Date
        {
            let trial = Calendar.current.date(byAdding: .day, value: val, to: Date())
            
            return trial!
        }

        func beginningOfTheDay(_ current : Date) -> Date
        {
            return Calendar.current.date(from:
                    Calendar.current.dateComponents([.year,.month,.day], from: current))!
        }

        var lastSeven : [Date] = []

        var count = 0

        while(count >= -6)
        {
            let current = getNewDate(count)
            let currentStart = beginningOfTheDay(current)
            lastSeven.append(currentStart)
            
            count -= 1
        }
    
        lastSeven = lastSeven.sorted()
       

        var parsedLastSeven : [(String, Int)] = []

        for currentDay in lastSeven
        {
            let nextDay = getNewDate(1, currentDay)
            var count = 0
            
            for val in newDates
            {
                if (val >= currentDay && val < nextDay)
                {
                    count += 1
                    
                }
                
            }
            
            let calanderDate = Calendar.current.dateComponents([.day, .month], from: currentDay)
            let month = calanderDate.month!
            let day = calanderDate.day!
            let str = "\(month)/\(day)"
            
            parsedLastSeven.append((str, count))
            
        }
        
        return parsedLastSeven
    }
    
   static func todayData(_ newDates : [Date]) -> [(String, Int)]
    {
        let newDates = newDates.sorted()
    
        //Algorithm for getting intervals today

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

        var todayIntervals : [(String, Int)] = []

        for val in newDates
        {
            if(val >= today && val < tomorrow)
            {
                let calanderDate = Calendar.current.dateComponents([.hour,.minute], from: val)
                
                let hourTest = calanderDate.hour!
                let minuteTest = calanderDate.minute!
                
                var hour = "\(calanderDate.hour!)"
                var minute = "\(calanderDate.minute!)"
                
                if(hourTest<10)
                {
                    hour = "0\(hour)"
                }
                if(minuteTest<10)
                {
                    minute = "0\(minute)"
                }
                
                let str = "\(hour):\(minute)"
                
                todayIntervals.append((str,1))
            
            }
        }

        return todayIntervals
    }
    
    static func intervalsToday(_ newDates : [Date]) -> Int
    {
    
        //Algorithm for getting intervals today
        
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

        var count = 0
        
        for val in newDates
        {
            if(val >= today && val < tomorrow)
            {
                count += 1
            }
        }

        return count
    }
    
    static func intervalsThisYear(_ newDates : [Date]) -> Int
    {
        //algorithm for all intervals completed this year
        
        func firstDayOfTheYear() -> Date
        {
                    return Calendar.current.date(from:
                            Calendar.current.dateComponents([.year], from: Date()))!
        }
        
        func nextYear() -> Date
        {
            let firstDay = firstDayOfTheYear()
            
            let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: firstDay)
            
            return nextYear!
        }
        
        let firstDay = firstDayOfTheYear()
        let nextYear = nextYear()
        
        var count = 0
        
        for x in newDates
        {
            if(x >= firstDay && x < nextYear)
            {
                count += 1
            }
            
        }
        
        return count
        
    }
    
    static func intervalsLastSeven(_ newDates : [Date]) -> Int
    {
        
        //Algorithm for getting data for last seven days
        
        func getNewDate(_ val : Int) -> Date
        {
            let trial = Calendar.current.date(byAdding: .day, value: val, to: Date())
            
            return trial!
        }
        
        
        func beginningOfTheDay(_ current : Date) -> Date
        {
            return Calendar.current.date(from:
                    Calendar.current.dateComponents([.year,.month,.day], from: current))!
        }
        
        let startDate = beginningOfTheDay(getNewDate(-6))
        
        var count = 0
        
        for x in newDates
        {
            if(x >= startDate)
            {
                count += 1
            }
            
        }

        return count
    }
    
    static func intervalsThisMonth(_ newDates : [Date]) -> Int
    {
        
        //Algorith for getting intervals this month
        
        func firstDayOfTheMonth(_ current : Date) -> Date
        {
                    return Calendar.current.date(from:
                            Calendar.current.dateComponents([.year,.month], from: current))!
        }
        
        func getSomeMonthFromDate(_ val : Int, _ date : Date) -> Date
        {
            
            let month = Calendar.current.date(byAdding: .month, value: val, to: date)
            
            return month!
        }
        
        let thisMonth = firstDayOfTheMonth(Date())
        let nextMonth = getSomeMonthFromDate(1, thisMonth)
        
        var count = 0
        
        for x in newDates
        {
            if(x >= thisMonth && x < nextMonth)
            {
                count += 1
            }
            
        }
        
        return count
    }
    
  
}

