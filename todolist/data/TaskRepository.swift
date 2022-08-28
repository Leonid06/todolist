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
    case all, completed, incompleted, today
}
class TaskRepository {
    
    private var tasks = [Task]()
    static let shared = TaskRepository()
    private let dateFormatter = DateFormatter()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(){
        dateFormatter.dateFormat = Constants.DateFormat
    }
    
    func addTask(title : String, description: String){
        let task = Task(context: context)
        
        task.title = title
        task.subtitle = description
        task.completed = false
        task.scheduled = false
    
        saveContext()
    }
    
    func addTodayTask(title : String, description: String, deadline : Date){
        let task = Task(context: context)
        
        task.title = title
        task.subtitle = description
        task.completed = false
        task.scheduled = false
        
        task.deadline = dateFormatter.string(from: deadline)
        
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
    
    func addDeadlineToTask(_ task : Task, deadline: String){
        task.scheduled = true
        task.deadline = deadline
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
    
    private func fetchTodayTasks()->[Task]{
        do {
            let today = dateFormatter.string(from: Date())
            let request = Task.fetchRequest()
            
            let todayPredicate = NSPredicate(format: "deadline == %@", today)
            let incompletedPredicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
            let finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [todayPredicate, incompletedPredicate])
            
            request.predicate = finalPredicate
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
        case .today:
            return fetchTodayTasks()
        }
    }
}
