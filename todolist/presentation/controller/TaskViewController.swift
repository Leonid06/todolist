//
//  TaskViewController.swift
//  todolist
//
//  Created by Leonid on 24.08.2022.
//

import UIKit

class TaskViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    private let repository = TaskRepository.shared
    private let task : Task
    var delegate : TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = task.title
        descriptionTextField.text = task.subtitle
    }
    
    init(task : Task){
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.task = Task()
        super.init(coder: coder)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        repository.updateTasks()
        delegate?.refreshData()
        print("tasks updated")
    }
}

//MARK: Delegates
protocol TaskViewControllerDelegate {
    func refreshData()
}

// MARK: Actions
extension TaskViewController : UITextFieldDelegate {
    
    @IBAction func titleTextFieldDidEditing(_ sender: UITextField) {
        print("task updated")
        task.title = titleTextField.text
    }
    @IBAction func descriptionTextFieldDidEditing(_ sender: UITextField) {
        print("task updated")
        task.subtitle = descriptionTextField.text
    }
    
}

