//
//  Task+CoreDataProperties.swift
//  todolist
//
//  Created by Leonid on 26.08.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var deadline: String?
    @NSManaged public var scheduled: Bool
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
