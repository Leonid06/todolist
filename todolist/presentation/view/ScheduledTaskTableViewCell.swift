//
//  ScheduledTaskTableViewCell.swift
//  todolist
//
//  Created by Leonid on 26.08.2022.
//

import UIKit
import Foundation

class ScheduledTaskTableViewCell: UITableViewCell {

    private let selectedImage = UIImage(systemName: "checkmark.circle.fill")
    private let unselectedImage = UIImage(systemName: "circle")
    
    private let dateFormatter = DateFormatter()
    
    @IBOutlet weak var scheduleImageView: UIImageView!
    @IBOutlet weak var titleEditText: UILabel!
    @IBOutlet weak var descriptionEditText: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    var indexPath : IndexPath?
    
    private var _task : Task = Task()
    private var state : CheckBoxState = .unselected
    
    
    var task : Task {
        set {
            _task = newValue
            titleEditText.text = _task.title
            descriptionEditText.text = _task.subtitle
            state = task.completed ? .selected : .unselected
            setDeadline()
            setCheckBoxImage()
        }
        get {
            return _task
        }
    }
    
    var delegate : TaskTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateFormat = Constants.DateFormat
        
        setCheckBoxImage()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkBoxImagePressed))
        
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func checkBoxImagePressed(recognizer: UITapGestureRecognizer){
        state = (state == .selected) ? .unselected : .selected
        setCheckBoxImage()
        
        if(state == .selected){
            if let indexPath = indexPath {
                delegate?.onTaskCompleted(indexPath: indexPath)
            }
        }else {
            if let indexPath = indexPath {
                delegate?.onTaskUndo(indexPath: indexPath)
            }
        }
        
    }
    
    private func setCheckBoxImage() {
        checkBoxImageView.image = (state == .selected) ? selectedImage : unselectedImage
    }
    
    private func setDeadline() {
        
        if let deadline = task.deadline {
            
            deadlineLabel.text =  deadline
            let today = dateFormatter.string(from: Date())
            let tomorrow = dateFormatter.string(from: Date().tomorrow ?? Date())
//            print(date)
//            print(date?.tomorrow)
            
            if(deadline == today){
                deadlineLabel.text = "Today"
                deadlineLabel.textColor = .systemGreen
                scheduleImageView.tintColor = .systemGreen
            }else if(deadline == tomorrow){
                deadlineLabel.text = "Tomorrow"
                deadlineLabel.textColor = .systemPurple
                scheduleImageView.tintColor = .systemPurple
            }else {
                deadlineLabel.text = deadline
                deadlineLabel.textColor = .systemBlue
                scheduleImageView.tintColor = .systemBlue
            }
        }
//        print(task.deadline)
        
    }
}
