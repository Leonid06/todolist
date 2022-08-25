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
}

class TaskTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var titleEditText: UILabel!
    @IBOutlet weak var descriptionEditText: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    var indexPath : IndexPath?
    
    private var _task : Task = Task()
    private var _state : CheckBoxState = .unselected
    
    var state : CheckBoxState {
        get {
            return _state
        }
        set {
            _state = newValue
            setCheckBoxImage()
        }
    }
    
    var task : Task {
        set {
            _task = newValue
            titleEditText.text = _task.title
            descriptionEditText.text =
            _task.subtitle
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
        
        setCheckBoxImage()
        
        _state = .unselected
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkBoxImagePressed))
        
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func checkBoxImagePressed(recognizer: UITapGestureRecognizer){
        _state = (_state == .selected) ? .unselected : .selected
        setCheckBoxImage()
        
        if(_state == .selected){
            if let indexPath = indexPath {
                delegate?.onTaskCompleted(indexPath: indexPath)
            }
        }
        
    }
    
    private func setCheckBoxImage() {
        checkBoxImageView.image = (_state == .selected) ? selectedImage : unselectedImage
    }
    
}
