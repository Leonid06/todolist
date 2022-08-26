//
//  TaskRepository.swift
//  todolist
//
//  Created by Leonid on 23.08.2022.
//

import Foundation
import CoreData
import UIKit

enum TasksFetchMode {
    case all, completed, incompleted
}
class TaskRepository {
    
    private var tasks = [Task]()
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
    
    func completeTask(_ task: Task){
        task.completed = true
        saveContext()
    }
    
    func undoTask(_ task: Task){
        task.completed = false
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
    
    private func fetchAllTasks() -> [Task]{
        do {
            let request = Task.fetchRequest()
            return try context.fetch(request).reversed()
        } catch {
            print(error)
        }
        return [Task]()
        
    }
    
    private func fetchIncompletedTasks()->[Task]{
        do {
            let request = Task.fetchRequest()
            let predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
            request.predicate = predicate
            return try context.fetch(request).reversed()
        } catch {
            print(error)
        }
        return [Task]()
    }
    
    private func fetchCompletedTasks() -> [Task]{
        do {
            let request = Task.fetchRequest()
            let predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
            request.predicate = predicate
            return try context.fetch(request).reversed()
        } catch {
            print(error)
        }
        return [Task]()
    }
    
    func fetchTasks(mode: TasksFetchMode) -> [Task]{
        switch mode{
        case .completed:
            return fetchCompletedTasks()
        case .incompleted:
            return fetchIncompletedTasks()
        case .all:
            return fetchAllTasks()
        }
    }
}
