//
//  InitalSheet.swift
//  IntervalsApp
//
//  Created by Samuel Shally  on 6/20/21.
//

import SwiftUI

struct InitalSheet: View
{
    @Binding var initalSheet : Bool
    
    var body: some View
    {
       NavigationView
       {
            ScrollView
            {
               VStack
               {
                  
                   GroupBox()
                   {
                
                       HStack
                       {
                           Text("Your Tasks")
                               .fixedSize(horizontal: false, vertical: true)
                               .font(.title2)
                               .foregroundColor(.green)
                           Spacer()
                       }
                       .padding([.bottom], 3)
                       
                       HStack
                       {
                           Text("Create a task, track your intervals, and discover trends in your data")
                               .fixedSize(horizontal: false, vertical: true)
                           Spacer()
                           
                       }
                       .padding([.bottom], 3)
                    
                    HStack
                    {
                        Text("Focus Sounds")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.title2)
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding([.bottom], 3)
                    
                    HStack
                    {
                        Text("Enjoy focus enhancing sounds to boost your productivity")
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        
                    }
                    .padding([.bottom], 3)
                    
                    HStack
                    {
                        Text("Cloud Sync")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.title2)
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding([.bottom], 3)
                    
                    HStack
                    {
                        Text("All your data is automatically synced across your devices")
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding([.bottom], 3)
                    
                    HStack
                    {
                        Text("Bug Reports")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.title2)
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding([.bottom], 3)
                    
                    HStack
                    {
                        Text("Please submit bug reports via the link on the settings page")
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        
                    }
                    .padding([.bottom], 3)
                
                   }
                  
               }
               .navigationTitle("Welcome!")
               
               .navigationBarItems(trailing: Button("Dismiss")
               {
                   
                   self.initalSheet = false
               })
            
               
               .frame(maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
               
               .padding(.top,30)
            
               
           
            }
            .fixFlickering
            {
                scrollView in
                
                scrollView
            }
        }
       .onAppear
       {
        
        NewData.defaults.set(true, forKey: "isFirst")
        
       }
    }
}


