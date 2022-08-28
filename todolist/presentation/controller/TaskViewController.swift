//
//  TaskViewController.swift
//  todolist
//
//  Created by Leonid on 24.08.2022.
//

import UIKit

class TaskViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    private let datePicker  = UIDatePicker()
    private let repository = TaskRepository.shared
    private let task : Task?
    private let dateFormatter = DateFormatter()
    
    var delegate : TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = task?.title
        descriptionTextField.text = task?.subtitle
        
        setupDatePicker()
        
        dateTextField.inputView = datePicker
        dateTextField.placeholder = dateFormatter.string(from: Date.now)
    }
    
    init(task : Task){
        
        self.task = task
        dateFormatter.dateFormat = Constants.DateFormat
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.task = Task()
        super.init(coder: coder)
    }
    
    private func setupDatePicker(){
        if let deadline = task?.deadline {
            if let scheduled = task?.scheduled {
                if(scheduled){
                    datePicker.date = dateFormatter.date(from: deadline) ?? Date()
                    dateTextField.text = deadline}
//                } else {
//                    let date = Date()
//                    datePicker.date = date
//                    dateTextField.text = dateFormatter.string(from: date)
//                }
            }
           
        }
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(onDatePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc private func onDatePickerValueChanged(_ sender : UIDatePicker){
        dateTextField.text = dateFormatter.string(from: sender.date)
        repository.addDeadlineToTask(task ?? Task(), deadline: dateTextField.text ?? "")
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
        task?.title = titleTextField.text
    }
    @IBAction func descriptionTextFieldDidEditing(_ sender: UITextField) {
        print("task updated")
        task?.subtitle = descriptionTextField.text
    }
    
}

