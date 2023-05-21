//
//  Task+CoreDataProperties.swift
//  IntervalsApp
//
//  Created by Samuel Shally on 8/2/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var data: [Date]?
    @NSManaged public var length: Double
    @NSManaged public var name: String?
    @NSManaged public var score: Double
    @NSManaged public var target: Double
    @NSManaged public var entry: NSSet?

}

// MARK: Generated accessors for entry
extension Task {

    @objc(addEntryObject:)
    @NSManaged public func addToEntry(_ value: Entry)

    @objc(removeEntryObject:)
    @NSManaged public func removeFromEntry(_ value: Entry)

    @objc(addEntry:)
    @NSManaged public func addToEntry(_ values: NSSet)

    @objc(removeEntry:)
    @NSManaged public func removeFromEntry(_ values: NSSet)

}

extension Task : Identifiable {

}
