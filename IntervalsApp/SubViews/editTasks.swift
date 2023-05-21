//
//  EditTasks.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 7/23/21.
//

import SwiftUI

struct EditTasks: View
{
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var indexes : Indexes
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks : FetchedResults<Task>
    
    @Binding var editTaskSheet : Bool
    
    //Task Values to Be Saved
    @State private var taskName = ""
    @State private var target = 0
    @State private var length = 0
    
    //Only for UI
    @State private var strLength = "00:00:00"
    @State private var hours = 0.0
    @State private var minutes = 0.0
    @State private var seconds = 0.0

    //prevent unnessesary setTimeInSeconds method calls
    @State private var initalized = false
    
   //For alerts
    @State private var alertValue = ""
    @State private var showAlert = false
    @State private var deleteAlert = false
  
    
    //Custom UI for general task
    @State private var isGeneral = false

        
    var body: some View
    {
        NavigationView
        {
            GeometryReader
            {
                geometry in
                
                ScrollView
                {
                    GroupBox()
                    {
                        VStack
                        {
                            GroupBox()
                            {

                                if(isGeneral)
                                {
                                    Text("General")
                                        .font(.title)
                                }
                                else
                                {
                                    Text("Name of Task")
                                    TextField("\(taskName)", text: $taskName)
                                        .font(.system(size: 25))
                                        .padding(.vertical,5)
                                        .padding(.horizontal, 20)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            Capsule()
                                                .fill(Color.gray)
                                                .opacity(0.75)
                                        )
                                        .padding([.top,.bottom],5)
                                }
                                    
                                    
                            }
                            
                           
                            GroupBox()
                            {
                                Text("Interval Length: \(self.strLength)")
                                    .font(geometry.size.width > 320 ? .none : .system(size: 15))
                                    .padding()
                                    
                               
                                GroupBox()
                                {
                                    Text("Hours")
                                    Slider(value: $hours, in: 0...23)
                                }
                                GroupBox()
                                {
                                    Text("Minutes")
                                    Slider(value: $minutes, in: 0...59)
                                }
                                GroupBox()
                                {
                                    Text("Seconds")
                                    Slider(value: $seconds, in: 0...59)
                                }
                            }
           
                            GroupBox
                            {
                                Text("Target: \(self.target)")
                                
                                Stepper(value: $target, in: 0...100)
                                {
                                    Spacer()
                                    
                                }
                            }
                                
                            HStack
                            {
                                Button(action:
                                {
                                    newSave()
                                })
                                {
                                    Text("Update")
                                        .font(geometry.size.width > 320 ? .system(size: 25) : .system(size: 15))
                                        .padding(.vertical,5)
                                        .padding(.horizontal, 20)
                                        .foregroundColor(.white)
                                        .background(
                                            Capsule()
                                                .fill(Color.blue)
                                                .opacity(0.75)
                                        )
                                        .padding()
                                }
                                .alert(isPresented: $showAlert)
                                {
                                    Alert(title: Text("Error"), message: Text("\(self.alertValue)"), dismissButton: .default(Text("Dismiss")))
                                }
                                
                                if(!isGeneral)
                                {
                                    Button(action:
                                    {
                                        self.deleteAlert = true
                                        print(self.deleteAlert)
                                    })
                                    {
                                        Text("Delete")
                                            .font(geometry.size.width > 320 ? .system(size: 25) : .system(size: 15))
                                            .padding(.vertical,5)
                                            .padding(.horizontal, 20)
                                            .foregroundColor(.white)
                                            .background(
                                                Capsule()
                                                    .fill(Color.blue)
                                                    .opacity(0.75)
                                            )
                                            .padding()
                                            .alert(isPresented: $deleteAlert)
                                            {
                                                Alert(
                                                    title: Text("Are You Sure You Want to Remove This Task?"),
                                                    message: Text("This action cannot be undone."),
                                                    primaryButton: .destructive(Text("Remove"))
                                                    {
                                                        removeItem()
                                                    },
                                                    secondaryButton: .cancel()
                                                )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    
                }
                .fixFlickering
                {
                    scrollView in

                    scrollView
//                        .background(Image("\(indexes.background)").resizable().aspectRatio(contentMode: .fill).frame(width: geometry.size.width).ignoresSafeArea().blur(radius: 6))

                }
                
                .navigationBarItems(trailing: Button(action:
                {
                    self.editTaskSheet = false
                })
                {
                    Text("Dismiss")
                })
                
                .navigationBarTitle(Text("Edit Task"), displayMode: .inline)
            }
            
        }
        .onAppear()
        {
            //prevent setTimeInSeconds() being called while hour, minute, and second and being set
            self.initalized = false
            
            update()
            sortTime()
            
            timeString(Double(self.length))
            
            self.initalized = true
        }
        
        .onChange(of: self.hours)
        {
            _ in
            
            if(initalized)
            {
                setTimeInSeconds()
            }
        }
        
        .onChange(of: self.minutes)
        {
            _ in
            
            if(initalized)
            {
                setTimeInSeconds()
            }
        }
        
        .onChange(of: self.seconds)
        {
            _ in
            
            if(initalized)
            {
                setTimeInSeconds()
            }
        }
    
    }
    
    func update()
    {
        //Set self.taskName user defaults
        if(NewData.defaults.string(forKey: "currentTask") != nil)
        {
             self.taskName = NewData.defaults.string(forKey: "currentTask")!
        }
        
        if(self.taskName == "General")
        {
            self.length = Int(NewData.cloudDefaults.double(forKey: "interval"))
            self.target = Int(NewData.cloudDefaults.double(forKey: "targetIntervalsIndex"))
            self.isGeneral = true
        }
        else
        {
            self.isGeneral = false
            //find obj from task name and set target and length
            for task in tasks
            {
                if(task.name != nil)
                {
                    if(task.name == self.taskName)
                    {
                        self.length = Int(task.length)
                        self.target = Int(task.target)
                    }
                }
            }
        }
    }
    
    func sortTime() -> Void
    {
        var accumulatedTime = Int(self.length)
        
        self.hours = Double(Int(accumulatedTime/3600))
        accumulatedTime -= Int(self.hours) * 3600
        
        self.minutes = Double(Int(accumulatedTime/60))
        accumulatedTime -= Int(self.minutes) * 60
        
        self.seconds = Double(Int(accumulatedTime))
    }
    
    func setTimeInSeconds() -> Void
    {
        self.hours = self.hours.rounded()
        self.minutes = self.minutes.rounded()
        self.seconds = self.seconds.rounded()
        
        let hoursInSec = self.hours * 3600
        let minutesInSec = self.minutes * 60
        let accumulatedTime = hoursInSec + minutesInSec + self.seconds
        
        self.length = Int(accumulatedTime)
         
         timeString(Double(accumulatedTime))
    }
    
    func timeString(_ accumulatedTime: TimeInterval) -> Void
    {
        let hours = Int(accumulatedTime) / 3600
        let minutes = Int(accumulatedTime) / 60 % 60
        let seconds = Int(accumulatedTime) % 60
        
        self.strLength =  String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func newSave() -> Void
    {
        
        if(doesNameExist())
        {
            self.alertValue = "The Task Entered Already Exists"
            self.showAlert = true
        }
        else if(length <= 0)
        {
            self.alertValue = "Task Length Must Be Greater Than Zero"
            self.showAlert = true
        }
        else
        {
            if(self.taskName == "General")
            {
                NewData.cloudDefaults.set(self.length, forKey: "interval")
                NewData.cloudDefaults.set(self.target, forKey: "targetIntervalsIndex")
            }
            else
            {
                for task in tasks
                {
                    if(task.name != nil)
                    {
                        //Because task name may have been changed we have to retrive the current task from userDefaults
                        var current = ""
                        if(NewData.defaults.string(forKey: "currentTask") != nil)
                        {
                             current = NewData.defaults.string(forKey: "currentTask")!
                        }
                        
                        //Find object based on name and update the name, length, and target
                        if(task.name == current)
                        {
                            task.name = self.taskName
                            task.length = Double(self.length)
                            task.target = Double(self.target)
                            
                            do
                            {
                                try self.viewContext.save()
                            }
                            catch
                            {
                                self.alertValue = "\(error)"
                                self.showAlert = true
                            }
                        }
                    }
                }
            }
            
            NewData.defaults.set(self.taskName, forKey: "currentTask")
            
            self.editTaskSheet = false
        }
    }
    
    func doesNameExist() -> Bool
    {
    
        for task in tasks
        {
            if((self.taskName == task.name || self.taskName == "General") && self.taskName != NewData.defaults.string(forKey: "currentTask"))
            {
                return true
            }
        }
        
        return false

    }
    
    func removeItem()
    {
        for task in tasks
        {
            if(task.name != nil)
            {
                if(task.name == self.taskName)
                {
                    viewContext.delete(task)
                }
                
            }
        }
        
        do
        {
            try self.viewContext.save()
        }
        catch
        {
            self.alertValue = "\(error)"
            self.showAlert = true
        }
        
        NewData.defaults.set("General", forKey: "currentTask")
        
        self.editTaskSheet = false
    }
    
    
}


//struct Tasks_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        Tasks()
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
//    }
//}
