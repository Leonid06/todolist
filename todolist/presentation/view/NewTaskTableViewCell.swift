//
//  NewTaskTableViewCell.swift
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
}

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleEditText: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    var state : CheckBoxState = .unselected
    var indexPath : IndexPath?
    private var _task : Task = Task()
    
    var task : Task {
        set {
            _task = newValue
            titleEditText.text = _task.title
        }
        get {
            return _task
        }
    }
    
    private let selectedImage = UIImage(systemName: "checkmark.circle.fill")
    private let unselectedImage = UIImage(systemName: "circle")
    
    var delegate : TaskTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        toggleCheckboxImage()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkBoxImagePressed))
        
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func checkBoxImagePressed(recognizer: UITapGestureRecognizer){
        state = (state == .selected) ? .unselected : .selected
        toggleCheckboxImage()
        if(state == .selected){
            if let indexPath = indexPath {
                delegate?.onTaskCompleted(indexPath: indexPath)
            }
        }
        
    }
    
    private func toggleCheckboxImage() {
        checkBoxImageView.image = (state == .selected) ? selectedImage : unselectedImage
    }
    
}
