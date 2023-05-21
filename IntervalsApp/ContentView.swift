//
//  ContentView.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 6/15/21.
//

import SwiftUI
import CoreData
import NotificationCenter


struct ContentView: View
{
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedTabViw = 1
    
    @ObservedObject var indexes : Indexes
    @ObservedObject var music = MusicPlayer()
    @ObservedObject var dataBuild = DataBuild()
    @ObservedObject var timerManager = TimerManager()

    init()
    {
        
        NewData.cloudDefaults.synchronize()
        
        if(NewData.cloudDefaults.bool(forKey: "hasData") == false)
        {
            NewData.createDefaults()
        }
        
        indexes = Indexes()
        
        //Check if timer was active when app was last closed
        if(NewData.defaults.string(forKey: "timerState") == "running")
        {
            timerManager.appRestartRunning()
        }
        
        //Check if timer was paused when app was closed
        if(NewData.defaults.string(forKey: "timerState") == "paused")
        {
            timerManager.appRestartPaused()
        }
                  
    }
            
    var body: some View
    {
        TabView(selection: $selectedTabViw)
        {
            ViewOne()
                .environmentObject(indexes)
                .environmentObject(dataBuild)
                .environmentObject(timerManager)
                .tabItem
                {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Tasks")
                }.tag(1)
            
            ViewTwo()
                .environmentObject(indexes)
                .environmentObject(dataBuild)
                .environmentObject(timerManager)
                .tabItem
                {
                    Image(systemName: "scroll")
                    Text("Data")
                }.tag(2)
  
            Sounds()
                .environmentObject(indexes)
                .environmentObject(music)
                .tabItem
                {
                    Image(systemName: "speaker.wave.2")
                    Text("Sounds")
                }.tag(3)
                        
            ViewThree()
                .environmentObject(indexes)
                .environmentObject(music)
                .tabItem
                {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }.tag(4)

        }
    
    }


}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
//
//       ContentView().environmentObject(Indexes())
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (3rd generation)"))
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
