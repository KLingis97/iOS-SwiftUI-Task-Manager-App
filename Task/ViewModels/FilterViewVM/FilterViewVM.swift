//
//  FilterViewVM.swift
//  Task
//
//  Created by Kyriakos Lingis on 15/11/2023.
//

import Foundation

class FilterViewVM: ObservableObject {
    
    func toggleCategory(_ category: FilterCategory, in selectedFilterCategories: Set<FilterCategory>) -> Set<FilterCategory> {
        var tempSelectedFilterCategories = selectedFilterCategories
        
        if tempSelectedFilterCategories.contains(category) {
            tempSelectedFilterCategories.remove(category)
        } else {
            tempSelectedFilterCategories.insert(category)
        }
        return tempSelectedFilterCategories
    }
    
    func isCategorySelected(_ category: FilterCategory, in selectedFilterCategories: Set<FilterCategory>) -> Bool {
        return selectedFilterCategories.contains(category)
    }
    
    func togglePriority(_ priority: FilterPriority, in selectedFilterPriorities: Set<FilterPriority>) -> Set<FilterPriority> {
        var tempSelectedFilterPriorities = selectedFilterPriorities
        
        if tempSelectedFilterPriorities.contains(priority) {
            tempSelectedFilterPriorities.remove(priority)
        } else {
            tempSelectedFilterPriorities.insert(priority)
        }
        return tempSelectedFilterPriorities
    }
    
    func isPrioritySelected(_ priority: FilterPriority, in selectedFilterPriorities: Set<FilterPriority>) -> Bool {
        return selectedFilterPriorities.contains(priority)
    }
}
