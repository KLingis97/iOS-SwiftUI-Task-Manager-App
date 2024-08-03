//
//  taskObject.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import Foundation

struct TaskObject: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var taskName: String
    var taskDescription: String
    var taskPriority: String
    var dueDate: Date
    var taskCategory: String
    var done: Bool
}
