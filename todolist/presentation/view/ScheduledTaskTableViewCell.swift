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
            setCheckBoxImage()
        }
        get {
            return _task
        }
    }
    
    var delegate : TaskTableViewCellDelegate?

    override func awakeFromNib() {
        //TO FIX :
//        setDate()
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
    
    private func setDate() {
        if let deadline = task.deadline {
            let calendar = Calendar.current
            let midnight = calendar.startOfDay(for: Date())
            let date = dateFormatter.date(from: deadline)
            if(date == Date.now){
                deadlineLabel.text = "Today"
                deadlineLabel.tintColor = .systemPurple
            }else if(date == calendar.date(byAdding: .day, value: 1, to: midnight)!){
                deadlineLabel.text = "Tomorrow"
                deadlineLabel.tintColor = .systemGreen
            }else {
                deadlineLabel.text = deadline
                deadlineLabel.tintColor = .systemBlue
            }
        }
        
    }
    
}
