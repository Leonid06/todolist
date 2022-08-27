//
//  Extensions.swift
//  todolist
//
//  Created by Leonid on 27.08.2022.
//

import Foundation

extension Date {
    var tomorrow: Date? {
            return Calendar.current.date(byAdding: .day, value: 1, to: self)
        }
}
