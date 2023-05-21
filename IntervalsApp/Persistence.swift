//
//  Persistence.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 6/15/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do
        {
            try viewContext.save()
        }
        catch
        {
        
            let nsError = error as NSError
            
            fatalError("Unresolved error \(nsError)")
        }
        
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "IntervalsApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error)")
                
            }
        })
    
    }
    
    func save() {
        let context = container.viewContext
       
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}
