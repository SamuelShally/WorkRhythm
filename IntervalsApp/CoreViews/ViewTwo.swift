//
//  ViewTwo.swift
//  PracticeTwo
//
//  Created by Samuel Shally on 6/5/21.
//

import SwiftUI
import Foundation
import CoreData
import Charts

struct ViewTwo: View
{
    //Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items : FetchedResults<Item>
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks : FetchedResults<Task>

    //Environment Objects
    @EnvironmentObject var indexes : Indexes
    @EnvironmentObject var dataBuild : DataBuild
    @EnvironmentObject var timerManager : TimerManager

    //Multiple Tasks UI
    @State private var taskName = "General"
    
    //Graph UI
    @State var graphOptionsIndex = 0
    @State var graphOptions = ["Year","Month","Week","Today"]
    
    @State private var textSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.width <= 320 ? 10 : 25
    
    @State private var switchTasksSheet = false

    var body: some View
    {
        NavigationView
        {
            GeometryReader
            {
                geometry in

                VStack(alignment: .center, spacing: 10)
                {
                    Group()
                    {
                        if (UIDevice.current.userInterfaceIdiom == .pad && geometry.size.width > 428)
                        {
                            Spacer()
                        }
                        
                        Picker(selection: $graphOptionsIndex, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/)
                        {
                            ForEach(0..<graphOptions.count, id: \.self)
                            {
                                Text(graphOptions[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding([.horizontal, .bottom])

                        Group()
                        {
                            HStack
                            {
                                
                                Text("Task")
                                Spacer()
                                Text("\(taskName) ")

                                Image(systemName: "chevron.forward").font(.system(size: 16, weight: .regular))
                                    

                               }
                               .font(.system(size: textSize))
                               .padding(.vertical,5)
                               .padding(.horizontal, 20)
                               .foregroundColor(self.timerManager.timerMode == .initial ? .white : .gray)
                               .frame(maxWidth: .infinity)
                               .background(
                                   RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.orange)
                                    .opacity(0.8)

                                )
                        }
                        .padding([.horizontal])
                        .onTapGesture
                        {
                            self.switchTasksSheet = true;
                        }
                        .disabled(self.timerManager.timerMode != .initial)
                            
                        Group()
                        {
                            if(graphOptions[graphOptionsIndex] == "Year")
                            {
                                GroupBox()
                                {
                                    GraphingTests(rawData : dataBuild.yearData, label : "This Year")
                                        .frame(height: 200)
                                        
                                }
                                .padding([.top, .bottom])
                                
                                HStack
                                {
                                 Text("Time")
                                 Spacer()
                                    Text("\(dataBuild.timeThisYear)")

                                }
                                .font(.system(size: textSize))
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
                                 Text("Intervals")
                                 Spacer()
                                    Text("\(dataBuild.yearIntervals)")

                                }
                                .font(.system(size: textSize))
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
                            else if(graphOptions[graphOptionsIndex] == "Month")
                            {
                                GroupBox()
                                {
                                    GraphingTests(rawData : dataBuild.monthData, label : "This Month")
                                        .frame(height: 200)
                                }
                                .padding([.top, .bottom])
                                
                                HStack
                                {
                                 Text("Time")
                                 Spacer()
                                    Text("\(dataBuild.timeThisMonth)")

                                }
                                .font(.system(size: textSize))
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
                                 Text("Intervals")
                                 Spacer()
                                    Text("\(dataBuild.monthIntervals)")

                                }
                                .font(.system(size: textSize))
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
                            else if(graphOptions[graphOptionsIndex] == "Week")
                            {
                                GroupBox()
                                {
                                    GraphingTests(rawData : dataBuild.lastSevenData, label : "Last Seven Days")
                                        .frame(height: 200)
                                }
                                .padding([.top, .bottom])
                                
                                HStack
                                {
                                 Text("Time")
                                 Spacer()
                                    Text("\(dataBuild.timeLastSeven)")

                                }
                                .font(.system(size: textSize))
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
                                 Text("Intervals")
                                 Spacer()
                                    Text("\(dataBuild.lastSevenIntervals)")

                                }
                                .font(.system(size: textSize))
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
                            else
                            {
                                GroupBox()
                                {
                                    GraphingTests(rawData : dataBuild.todayData, label : "Today")
                                        .frame(height: 200)
                                }
                                .padding([.top, .bottom])
                                
                               
                                HStack
                                {
                                 Text("Time")
                                 Spacer()
                                 Text("\(dataBuild.timeToday)")

                                }
                                .font(.system(size: textSize))
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
                                 Text("Intervals")
                                 Spacer()
                                    Text("\(dataBuild.intervalsToday)/\(dataBuild.targetIntervals)")

                                }
                                .font(.system(size: textSize))
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
                        }
                        .padding([.horizontal])
                        .navigationBarTitle("Data", displayMode: .large)
                        
                        
                        Spacer()
                    }
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad && geometry.size.width >= 450 ?  geometry.size.width/2 :  geometry.size.width)
                    
                    
                }
                
                .frame(width: geometry.size.width , height : geometry.size.height)
                
                .background(
                        Image("\(indexes.background)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .blur(radius: 6)
                )

            }
           
        }
        .navigationViewStyle(StackNavigationViewStyle())


        .onAppear()
        {
            update()
        }

        .onChange(of : indexes.taskIndex)
        {
            _ in
            
            updateCurrentTask()

            dataBuild.update()

            updateTaskName()
        }
        
        .onChange(of : tasks.count)
        {
            _ in
            
            getTasks()
            
            dataBuild.update()

            updateTaskName()
        }
        
        .sheet(isPresented: $switchTasksSheet)
        {
            SwitchTasks(switchTasksSheet: $switchTasksSheet)
                .environmentObject(indexes)
        }
        
        .onChange(of: self.switchTasksSheet)
        {
            _ in
            
            getTasks()
            updateTaskIndex()
        
            dataBuild.update()
            
            updateTaskName()
        }

    }

    func update()
    {
        getTasks()
        
        dataBuild.update()

        updateTaskName()
    }

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
        

        var count = 0
        
        for x in indexes.taskValues
        {
            if(x == current)
            {
                indexes.taskIndex = count
                break
            }
            
            count += 1
        }
    }
    
    //revert to general task if there is some error
    func  taskError()
    {
        NewData.defaults.set("General", forKey: "currentTask")
        
        getTasks()
        updateTaskIndex()
        dataBuild.update()
        updateTaskName()
    }
 
}



struct ViewTwo_Previews: PreviewProvider
{
    static var previews: some View
    {
        ViewTwo()
            .environmentObject(Indexes())
            .environmentObject(DataBuild())
            .environmentObject(TimerManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
