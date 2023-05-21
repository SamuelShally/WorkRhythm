//
//  SwitchTasks.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 9/17/21.


// TODO: check if this switchTasks.swift is apart of the launch files

import SwiftUI

struct SwitchTasks: View
{
    @EnvironmentObject var indexes : Indexes
    @EnvironmentObject var dataBuild : DataBuild
    @EnvironmentObject var timerManager : TimerManager
    
    @Binding var switchTasksSheet : Bool
    
    var body: some View
    {
        NavigationView
        {
            
            List(indexes.taskValues, id: \.self)
            {
                item in
               
                HStack
                {
                    if(item == NewData.defaults.string(forKey: "currentTask"))
                    {
                        Image(systemName: "checkmark").font(.system(size: 16, weight: .regular))
                    }
                    else
                    {
                        Text("    ")
                    }
                    
                    Button(action : {NewData.defaults.set(item, forKey: "currentTask"); switchTasksSheet = false})
                    {
                        HStack
                        {

                            Text(item)
                        }
                    }
                }
                
            }
            
            .navigationBarTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar{
              
                ToolbarItem(placement: .navigationBarLeading)
                {
                    Button(action:
                    {
                        self.switchTasksSheet = false
                        
                    })
                    {
                        Text("Dismiss")
                    }
                    .frame(alignment: .leading)
                    .disabled(self.timerManager.timerMode != .initial)
                }
     
            }
             
        }
        
    }
}

