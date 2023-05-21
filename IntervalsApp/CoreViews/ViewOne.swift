//
//  ViewOne.swift
//  PracticeTwo
//
//  Created by Samuel Shally on 6/5/21.
//

import SwiftUI
import Foundation
import UserNotifications
import CoreData

struct ViewOne: View
{
    //Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items : FetchedResults<Item>
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks : FetchedResults<Task>
    
    
    //Environment Objects
    @EnvironmentObject var indexes : Indexes
    @EnvironmentObject var dataBuild : DataBuild
    @EnvironmentObject var timerManager : TimerManager 
       
      
    //Sheets
    @State private var initalSheet = false
    @State private var addTaskSheet = false
    @State private var editTaskSheet = false
    @State private var switchTasksSheet = false
    
    //For Alerts
    @State private var saveAlert = false
    @State private var errorVal = ""
    
    //Multiple Tasks UI
    @State private var taskName = "General"
    
    let timerSize: CGFloat = 40;
  

    var body: some View
    {
        NavigationView
        {
            GeometryReader
            {
                geometry in
                
                VStack(spacing: 10)
                {
                    
                        Group
                        {
                        
                            ZStack
                            {
                                Circle()
                                .trim(from: 0, to: 1)
                                    .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: geometry.size.width*0.7, height: geometry.size.height*0.5)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(timerManager.graphic))
                                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .frame(width: geometry.size.width*0.7, height: geometry.size.height*0.5)
                                .rotationEffect(.init(degrees: -90))
                                
                            VStack
                            {
                              
                                Text("\(timeString(timerManager.secondsLeft))")
                                    .font(.system(size: timerSize))
                                    
                                if (timerManager.timerMode == .running)
                                {
                                    HStack
                                    {
                                     Text("End Time:")
                                     Text("\(endTimeFormated())")
                                     
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                }
                                
                            }
                                
                        }
                    
                        HStack
                            {
                                
                                Image(systemName: timerManager.timerMode == .running ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60 , height : 60)
                                    .onTapGesture(perform:
                                    {
                                        self.timerManager.timerMode == .running ? self.timerManager.pause() : self.timerManager.start()
                                        
                                        self.timerManager.timerMode == .running ? self.addNotification() : self.removeNotification()
                                        
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                    })
                            
                                Spacer()
                            
                                Image(systemName : "stop.circle.fill" )
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .onTapGesture(perform:
                                    {
                                        self.timerManager.reset()
                                        self.updateTimer()
                                        self.removeNotification()
                                        
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                    })

                        }
                        .padding([.horizontal])
                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad && geometry.size.width >= 450 ?  geometry.size.width/2 :  geometry.size.width)
                      
                        }

                    Group
                    {
                        HStack
                        {
                            
                            Text("Task")
                            Spacer()
                            Text("\(taskName) ")

                            Image(systemName: "chevron.forward").font(.system(size: 16, weight: .regular))
                                

                           }
                           .font(.system(size: 25))
                           .padding(.vertical,5)
                           .padding(.horizontal, 20)
                           .foregroundColor(self.timerManager.timerMode == .initial ? .white : .gray)
                           .frame(maxWidth: .infinity)
                           .background(
                               RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.orange)
                                .opacity(0.8)

                            )
                        .onTapGesture
                        {
                            self.switchTasksSheet = true;
                        }
                        .disabled(self.timerManager.timerMode != .initial)
                     
                            HStack
                            {
                             Text("Today")
                             Spacer()
                                Text("\(dataBuild.intervalsToday)/\(dataBuild.targetIntervals)")
                             
                            }
                            .font(.system(size: 25))
                            .padding(.vertical,5)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                     .fill(Color.gray)
                                    .opacity(0.8)
                                     
                             )
                        
                            HStack
                            {
                             Text("High Score")
                             Spacer()
                             Text("\(dataBuild.highScore)")

                            }
                            .font(.system(size: 25))
                            .padding(.vertical,5)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                     .fill(Color.gray)
                                    .opacity(0.8)
                                     
                             )
                                
                        }
                        .padding([.horizontal])
//                        .frame(width: geometry.size.width > 428 ? 392 : geometry.size.width)
                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad && geometry.size.width >= 450 ?  geometry.size.width/2 :  geometry.size.width)
                       
                    Spacer()
                        
                    }
                    
                .frame(width: geometry.size.width, height : geometry.size.height)
                
                .background(
                        Image("\(indexes.background)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .blur(radius: 6)
                )

        
            }
            .navigationBarTitle("", displayMode : .large)
            
            .toolbar{
              
                ToolbarItem(placement: .navigationBarLeading)
                {
                    Button(action:
                    {
                        self.editTaskSheet = true
                    })
                    {
                        Text("Edit")
                    }
                    .frame(alignment: .leading)
                    .disabled(self.timerManager.timerMode != .initial)
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button(action:
                    {
                        self.addTaskSheet = true
                        
                    })
                    {
                       
                        Text("Add")
                        
                    
                    }
                    .frame(alignment: .leading)
                    .disabled(self.timerManager.timerMode != .initial)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
            
        .onAppear
        {
            update()
            firstLaunch()
        }
        
        .onChange(of: timerManager.isDone)
        { _ in
            
            timerDone()
        }
        
        //Multiple task action listeners
        .onChange(of : indexes.taskIndex)
        {
            _ in

            updateCurrentTask()
            updateTimer()
            
            dataBuild.update()
            
            updateTaskName()

        }
        
        .onChange(of: self.editTaskSheet)
        {
            _ in
            
            getTasks()
            updateTaskIndex()
            updateTimer()
            
            dataBuild.update()
            
            updateTaskName()

        }
        
        .onChange(of: self.addTaskSheet)
        {
            _ in
        
            getTasks()
            updateTaskIndex()
            updateTimer()
            
            dataBuild.update()
            
            updateTaskName()

        }
        
        .onChange(of: self.switchTasksSheet)
        {
            _ in
            
            getTasks()
            updateTaskIndex()
            updateTimer()
            
            dataBuild.update()
            
            updateTaskName()
        }
        
        .onChange(of : tasks.count)
        {
            _ in

            update()
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification))
        {
            _ in
            
            enteredFromBackground()
        }
        
        .alert(isPresented: $saveAlert)
        {
            Alert(title: Text("ERROR"), message: Text("Interval Could Not Be Saved\n\(self.errorVal)"), dismissButton: .default(Text("Dismiss")))
        }
        
        .sheet(isPresented: $initalSheet)
        {
            InitalSheet(initalSheet: $initalSheet)
        }
        
        .sheet(isPresented: $addTaskSheet)
        {
            CreateTask(addTaskSheet: $addTaskSheet)
                .environmentObject(indexes)
                .environment(\.managedObjectContext, self.viewContext)
        }
        
        .sheet(isPresented: $editTaskSheet)
        {
            EditTasks(editTaskSheet: $editTaskSheet)
                .environmentObject(indexes)
                .environment(\.managedObjectContext, self.viewContext)
        }
        
        .sheet(isPresented: $switchTasksSheet)
        {
            SwitchTasks(switchTasksSheet: $switchTasksSheet)
                .environmentObject(indexes)
        }
        
    }
    
   
    func update() -> Void
    {
    
        getTasks()
        updateTaskIndex()
        
        dataBuild.update()
        
        updateTimer()
        
        updateTaskName()
    }
   
    
   //Creates an array of task obj names
    func getTasks() -> Void
    {
        var newTasks : [String] = []
        
        for x in tasks
        {
            if(x.name != nil)
            {
                newTasks.append(x.name!)
            }
        }
        
        newTasks = newTasks.sorted()
        newTasks.insert("General", at: 0)
    
        indexes.taskValues = newTasks
    }
    
    //Update userDefaults from taskValues[taskIndex]
    func  updateCurrentTask() -> Void
     {
        if(indexes.taskIndex >= indexes.taskValues.count)
        {
            taskError()
        }
        else
        {
            NewData.defaults.set(indexes.taskValues[indexes.taskIndex], forKey: "currentTask")
        }
     }
    
    //updates self.taskName for the picker label
    func updateTaskName()
    {
        if(indexes.taskIndex >= indexes.taskValues.count)
        {
            taskError()
        }
        else
        {
            self.taskName = indexes.taskValues[indexes.taskIndex]
        }

    }
    
    //sets sets current index from user default task name
    func updateTaskIndex()
    {
        var current = ""
        if(NewData.defaults.string(forKey: "currentTask") != nil)
        {
             current = NewData.defaults.string(forKey: "currentTask")!
        }
        
        var taskFound = false
        var count = 0
        
        for x in indexes.taskValues
        {
            if(x == current)
            {
                indexes.taskIndex = count
                taskFound = true
                
                break
            }
            
            count += 1
        }
        
        if(taskFound == false)
        {
            taskError()
        }
    }
    
    func updateTimer()
    {
        var current = ""
        if(NewData.defaults.string(forKey: "currentTask") != nil)
        {
             current = NewData.defaults.string(forKey: "currentTask")!
        }
        
        if(current == "General")
        {
            if(timerManager.timerMode == .initial)
            {
                timerManager.secondsLeft = NewData.cloudDefaults.double(forKey: "interval")
                timerManager.graphic = 1
            }

            timerManager.timerLength = NewData.cloudDefaults.double(forKey: "interval")
        }
        else
        {
            for task in tasks
            {
                if(task.name == current)
                {
                    
                    if(timerManager.timerMode == .initial)
                    {
                        timerManager.secondsLeft = task.length
                        timerManager.graphic = 1
                    }

                    timerManager.timerLength = task.length

                    break
                }
            }
        }
    }
    
    //revert to general task if there is some error
    func  taskError()
    {
        NewData.defaults.set("General", forKey: "currentTask")
        
        getTasks()
        updateTaskIndex()
        dataBuild.update()
        updateTimer()
        updateTaskName()
        
        if(timerManager.timerMode == .running || timerManager.timerMode == .paused)
        {
            self.removeNotification()
            timerManager.reset()
            self.updateTimer()
        }
    }
       
    //called when timer is done
    func timerDone() -> Void
    {
        if(timerManager.isDone == true)
        {
            addInterval()
            dataBuild.update()
                
            updateHighScore()
            
            update()
        
            timerManager.isDone = false
        }
    }
    
    func addInterval() -> Void
    {
        let current = NewData.defaults.string(forKey: "currentTask")

        if(current == "General")
        {
            let newDate = Item(context: self.viewContext)
            newDate.timestamp = timerManager.endTime
            newDate.length = NewData.cloudDefaults.double(forKey: "interval")
                    
            do
            {
                try self.viewContext.save()
            }
            catch
            {
                self.errorVal = "\(error)"
                self.saveAlert = true
            }
        }
        else
        {
            for task in tasks
            {
                if(task.name == current)
                {
                    
                    let newDate = Entry(context: self.viewContext)
                    newDate.timestamp = timerManager.endTime
                    newDate.length = task.length
                    
                    task.addToEntry(newDate)
 
                    do
                    {
                        try self.viewContext.save()
                    }
                    catch
                    {
                        self.errorVal = "\(error)"
                        self.saveAlert = true
                    }
                    
                    break
                }
            }
        }
    }
    
    func updateHighScore()
    {
        let current = NewData.defaults.string(forKey: "currentTask")
 
        if(current == "General")
        {
            
            if(dataBuild.intervalsToday > dataBuild.highScore)
            {
                NewData.cloudDefaults.set(dataBuild.intervalsToday, forKey: "highScore")
            }
            
        }
        else
        {

            if(dataBuild.intervalsToday > dataBuild.highScore)
            {
                for task in tasks
                {
                    if(task.name == current)
                    {
                        task.score = task.score + 1
                        
                        do
                        {
                            try self.viewContext.save()
                        }
                        catch
                        {
                            self.errorVal = "\(error)"
                            self.saveAlert = true
                        }
                        
                        break
                    }
                }
            }
        }
    }
    
    func addNotification() -> Void
    {
        var current = ""
        if(NewData.defaults.string(forKey: "currentTask") != nil)
        {
             current = NewData.defaults.string(forKey: "currentTask")!
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = "Interval Completed!"
        content.body = "You've completed \(dataBuild.intervalsToday+1)/\(dataBuild.targetIntervals) intervals for \(current)"
        
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timerManager.secondsLeft, repeats: false)

        let request = UNNotificationRequest(identifier: "intervalDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func removeNotification() -> Void
    {
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: ["intervalDone"])
        
    }
    
    func enteredFromBackground() -> Void
    {
        if(self.timerManager.timerMode == .running)
        {
            timerManager.fromBackground()
        }
        
        update()
    }
    
    func firstLaunch() -> Void
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge])
        {
            (_,_) in
        }
        
        
        if( NewData.defaults.bool(forKey: "isFirst") == false)
        {
            self.initalSheet = true
        }
    }
    
    func endTimeFormated() -> String
    {
        let calanderDate = Calendar.current.dateComponents([.hour,.minute], from: timerManager.endTime
        )

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
        
        return str
    }
    
    func timeString(_ accumulatedTime: TimeInterval) -> String
    {
    
        if(accumulatedTime >= 0)
        {
            let hours = Int(accumulatedTime) / 3600
            let minutes = Int(accumulatedTime) / 60 % 60
            let seconds = Int(accumulatedTime) % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
        else
        {
            let hours = 0
            let minutes = 0
            let seconds = 0
            
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
}

struct ViewOne_Previews: PreviewProvider
{
    
    static var previews: some View
    {
        
        ViewOne()
            .environmentObject(Indexes())
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}


struct WhiteProgressViewStyle: ProgressViewStyle
{
    func makeBody(configuration: Configuration) -> some View
    {
        ProgressView(configuration)
            
            .accentColor(.white)
            
    }

}
