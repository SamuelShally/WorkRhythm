//
//  IntervalsAppApp.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 6/15/21.
//

import SwiftUI
import CoreData

@main
struct IntervalsAppApp: App
{
    let persistenceController = PersistenceController.shared

    init()
    {
        persistenceController.container.viewContext.automaticallyMergesChangesFromParent = true
        
    }
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
        
}
