//
//  TaskRepository.swift
//  todolist
//
//  Created by Leonid on 23.08.2022.
//

import Foundation
import CoreData
import UIKit

class TaskRepository {
    
    private var _tasks = [Task]()
    static let shared = TaskRepository()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addTask(title : String, description: String, deadline : NSDate){
        let task = Task(context: context)
        
        task.title = title
        task.subtitle = description
        task.completed = false
        
//        let deadline = deadline.timeIntervalSince1970.bitPattern
//        task.deadline = Int64(bitPattern: deadline)
        
        saveContext()
    }
    
    func updateTasks(){
        saveContext()
    }
    
    func deleteTask(_ task : Task){
        context.delete(task)
        saveContext()
    }
    
    
    private func saveContext(){
        do {
            try context.save()
            print("task saved")
        }catch {
            print(error)
        }
    }
    
    var tasks : [Task] {
        
        do {
            let request = Task.fetchRequest()
            _tasks = try context.fetch(request).reversed()
        } catch {
            print(error)
        }
        
       return _tasks
    }
}
