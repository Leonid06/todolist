//
//  TaskTableViewCell.swift
//  todolist
//
//  Created by Leonid on 25.08.2022.
//

import UIKit

enum CheckBoxState {
    case selected, unselected
}

protocol TaskTableViewCellDelegate {
    func onTaskCompleted(indexPath : IndexPath)
    func onTaskUndo(indexPath: IndexPath)
}

class TaskTableViewCell: UITableViewCell {
    
    private let selectedImage = UIImage(systemName: "checkmark.circle.fill")
    private let unselectedImage = UIImage(systemName: "circle")
    
   
    @IBOutlet weak var titleEditText: UILabel!
    @IBOutlet weak var descriptionEditText: UILabel!
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
        super.awakeFromNib()
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
    
}
