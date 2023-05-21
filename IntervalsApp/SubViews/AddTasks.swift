//
//  Tasks.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 7/14/21.
//

import SwiftUI

struct CreateTask: View
{
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var indexes : Indexes
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks : FetchedResults<Task>

    @Binding var addTaskSheet : Bool
    
    //To save in task obj
    @State private var taskName = ""
    @State private var length = 0
    @State private var target = 0
  
    //Only for UI
    @State private var strLength = "00:00:00"
    @State private var hours = 0.0
    @State private var minutes = 0.0
    @State private var seconds = 0.0
    
    //for Alerts
    @State private var showAlert = false
    @State private var alertValue = ""
    
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
                        
                                Text("Name of Task")
                                
                                TextField("Type Here", text: $taskName)
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
                                
                            
                                    
                            Button(action:
                            {
                                newSave()
                            })
                            {
                                Text("Create")
                                    .font(.system(size: 25))
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
                    self.addTaskSheet = false
                })
                {
                    Text("Dismiss")
                })
                
                .navigationBarTitle(Text("Add Task"), displayMode: .inline)
            }
            
        }
        
        .onChange(of: self.hours)
        {
            _ in
            
            setTimeInSeconds()
        }
        
        .onChange(of: self.minutes)
        {
            _ in
            
            setTimeInSeconds()
        }
        
        .onChange(of: self.seconds)
        {
            _ in
            
            setTimeInSeconds()
        }
                
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
            //write interval to core data
            let newTask = Task(context: self.viewContext)
            
            newTask.name = self.taskName
            newTask.length = Double(self.length)
            newTask.target = Double(self.target)
            
            newTask.score = Double(0)
            newTask.data = []
            
            do
            {
                try self.viewContext.save()
            }
            catch
            {
                self.alertValue = "\(error)"
                self.showAlert = true
            }
            
            NewData.defaults.set("\(self.taskName)", forKey: "currentTask")
            
            self.addTaskSheet = false
        }
    }
    
    
    func doesNameExist() -> Bool
    {
 
        for task in tasks
        {
            if(self.taskName == task.name || self.taskName == "General")
            {
                return true
            }
        }
        
        return false

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
