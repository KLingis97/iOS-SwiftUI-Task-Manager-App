//
//  FiltersCategory.swift
//  Task
//
//  Created by Kyriakos Lingis on 15/11/2023.
//

import Foundation

enum FilterCategory: String, CaseIterable{
    case work = "Work", gym = "Gym", education = "Education", other = "Other"
}

enum FilterPriority: String, CaseIterable{
    case low = "Low", normal = "Normal", high = "High"
}

enum FilterStatus: String, CaseIterable{
    case done = "Completed", all = "All", unDone = "Incomplete"
}

enum Sorting: String {
    case name = "Name", dueDate = "dueDate", category = "Category", priority = "Priority"
}
