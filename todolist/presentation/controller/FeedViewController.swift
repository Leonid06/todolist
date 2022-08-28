//
//  ViewController.swift
//  todolist
//
//  Created by Leonid on 23.08.2022.
//

import UIKit

class FeedViewController: UITableViewController {
    
    private var tasks  = [Task]()
    
    private let defaultCellIdentifier = Constants.Identifiers.DefaultViewCellIdentifier
    private let taskTableViewCellIdentifier = Constants.Identifiers.TaskViewCellIdentifier
    private let scheduledTaskTableViewIdentifier = Constants.Identifiers.ScheduledTaskViewCellIdentifier
    
    private let repository = TaskRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellIdentifier)
        tableView.register(UINib(nibName: Constants.NibNames.TaskTableViewCellNibName, bundle: nil), forCellReuseIdentifier: taskTableViewCellIdentifier)
        tableView.register(UINib(nibName: Constants.NibNames.ScheduledTaskTableViewCellNibName, bundle: nil), forCellReuseIdentifier: scheduledTaskTableViewIdentifier)
        
        updateTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTasks()
    }
}

extension FeedViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = tasks[indexPath.row]
        return task.scheduled ?  72 : 56
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        if(task.scheduled){
            let cell = tableView.dequeueReusableCell(withIdentifier: scheduledTaskTableViewIdentifier) as! ScheduledTaskTableViewCell
            
            cell.task = task
            cell.delegate = self
            cell.indexPath = indexPath
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskTableViewCellIdentifier) as! TaskTableViewCell
            
            cell.task = task
            cell.delegate = self
            cell.indexPath = indexPath
            
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let taskViewController = TaskViewController(task: selectedTask)
        
        if let sheet = taskViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        taskViewController.delegate = self
        
        present(taskViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let task = tasks[indexPath.row]
            repository.deleteTask(task)
            
            updateTasks()
        }
    }
}

extension FeedViewController {
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add new task", message: nil, preferredStyle: .alert)
        
        alert.addTextField {
            textField in
            textField.placeholder = "Enter a title"
        }
        
        alert.addTextField{
            textField in
            textField.placeholder = "Enter a description"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default){
            action in
            if let textFields = alert.textFields {
                let title = textFields[0].text
                let description = textFields[1].text
                
                self.repository.addTask(title: title ?? "Default title", description: description ?? "Default description")
                
                self.updateTasks()
            }
        }
        let deleteAction =  UIAlertAction(title: "Cancel", style: .cancel){
            action in
            alert.dismiss(animated: true)
        }
        alert.addAction(addAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
}

extension FeedViewController : TaskViewControllerDelegate  {
    func refreshData() {
        self.updateTasks()
    }
    private func updateTasks(){
        tasks = repository.fetchTasks(mode: .incompleted)
        tableView.reloadData()
    }
}

extension FeedViewController : TaskTableViewCellDelegate {
    func onTaskCompleted(indexPath : IndexPath) {
        let task = tasks[indexPath.row]
        repository.completeTask(task)
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        updateTasks()
    }
    
    func onTaskUndo(indexPath: IndexPath) {
        return 
    }
}


