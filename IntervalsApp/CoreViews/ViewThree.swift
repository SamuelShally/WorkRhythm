//
//  ViewThree.swift
//  PracticeTwo
//
//  Created by Samuel Shally on 6/5/21.
//

import SwiftUI
import NotificationCenter

struct ViewThree: View
{
    //Enviroment Objects
    @EnvironmentObject var indexes : Indexes
    @EnvironmentObject var music : MusicPlayer
                
    //For Sheets
    @State private var backgroundSheet = false
    
    var body: some View
    {
        
        NavigationView
        {
            Form
            {

                Section(header: Text("Options"))
                {
        
                    HStack
                    {

                        Button(action: {self.backgroundSheet = true})
                        {
                            Text("Background")
                        }

                    }
                    
                }

        
                Section(header: Text("Extras"))
                {
                    
                    HStack
                    {
                        
                        NavigationLink("Feedback and Bug Reports", destination: Webview(url: "https://samuelshally.com/pageOne.html").edgesIgnoringSafeArea(.all))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                      
                    }
                    
                    HStack
                    {
                        
                        NavigationLink("Feature Request", destination: Webview(url: "https://samuelshally.com/priorityFeatureRequests.html").edgesIgnoringSafeArea(.all))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                      
                    }
                    
                    HStack
                    {
                        
                        NavigationLink("Privacy Policy", destination: Webview(url: "https://samuelshally.com/pageTwo.html").edgesIgnoringSafeArea(.all))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                      
                    }
                    
                }
                
                Section(header: Text("About this app"))
                {
                    
                    HStack
                    {
                        Text("Name: ")
                        Spacer()
                        Text("Work Rhythm")
                    }
                    
                    HStack
                    {
                        Text("Version: ")
                        Spacer()
                        Text("1.4.0")
                    }
                    
                    HStack
                    {
                        Text("Developed By: ")
                        Spacer()
                        Text("Samuel Shally")
                    }
                    
                }
                
            }
            .navigationBarTitle("Settings", displayMode: .inline)

            .sheet(isPresented: $backgroundSheet)
            {
                BackgroundPicker( backgroundSheet: $backgroundSheet).environmentObject(self.music)
            }
              
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

struct ViewThree_Previews: PreviewProvider
{
    static var previews: some View
    {
        ViewThree()
            .environmentObject(Indexes())
            .environmentObject(MusicPlayer())
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
            
    }
}
