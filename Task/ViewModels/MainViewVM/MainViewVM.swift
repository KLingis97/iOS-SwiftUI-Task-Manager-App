//
//  MainViewVM.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import Foundation
import SwiftUI
import UserNotifications

class MainViewVM: ObservableObject {
    
    @Published var selectedFilterCategories: Set<FilterCategory> = []
    @Published var selectedFilterPriorities: Set<FilterPriority> = []
    @Published var fromDate: Date = .now
    @Published var toDate: Date = .now
    @Published var fromDateToggle: Bool = false
    @Published var toDateToggle: Bool = false
    @Published var selectedSorting: String = Sorting.dueDate.rawValue
    @Published var sortingDescending: Bool = false
    @Published var taskStatus: FilterStatus = FilterStatus.all
    @Published var rotationArrow: Double = 0.0
    @Published var isUpdated: Bool = false
    
    @Published var tasks = [String:TaskObject](){
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(tasks){
                UserDefaults.standard.set(encoded, forKey: "Tasks")
            }
        }
    }
    
    init(){
        if let saveditems = UserDefaults.standard.data(forKey: "Tasks"){
            if let decodedItems = try? JSONDecoder().decode([String:TaskObject].self, from: saveditems){
                tasks = decodedItems
                checkTasksForToday()
                return
            }
        }
        tasks = [:]
    }
    
    func keysToDisplay(for searchResults:[String: TaskObject]) -> [String] {
        withAnimation(Animation.bouncy.speed(2.0)){
            var toDisplay: [String: TaskObject]
            if isUpdated {
                toDisplay = tasks
                isUpdated = false
            } else {
                toDisplay = searchResults
            }
            
            let sortedKeys = toDisplay.keys.sorted(by: { key1, key2 in
                let task1 = toDisplay[key1]
                let task2 = toDisplay[key2]
                
                switch selectedSorting {
                case Sorting.dueDate.rawValue:
                    return task1?.dueDate ?? .now  < task2?.dueDate ?? .now
                case Sorting.name.rawValue:
                    return task1?.taskName ?? ""  < task2?.taskName ?? ""
                case Sorting.category.rawValue:
                    return task1?.taskCategory ?? ""  < task2?.taskCategory ?? ""
                case Sorting.priority.rawValue:
                    let priority1 = task1?.taskPriority == FilterPriority.low.rawValue ? 1 : task1?.taskPriority == FilterPriority.normal.rawValue ? 2 : 3
                    let priority2 = task2?.taskPriority == FilterPriority.low.rawValue ? 1 : task2?.taskPriority == FilterPriority.normal.rawValue ? 2 : 3
                    return priority1  < priority2
                default:
                    return key1 < key2
                }
            })
            
            let filteredKeys = filter(searchResults: toDisplay, sortedKeys: sortedKeys)
            
            let keysToDisplay = sortingDescending ? filteredKeys.reversed() : filteredKeys
            
            return keysToDisplay
        }
    }
    
    func filter(searchResults: [String: TaskObject], sortedKeys: [String]) -> [String] {
        withAnimation(Animation.bouncy.speed(2.0)) {
            return sortedKeys.filter { key in
                guard let task = searchResults[key] else {
                    return false
                }
                
                let categoryMatch = selectedFilterCategories.isEmpty || selectedFilterCategories.contains(where: { category in
                    task.taskCategory.elementsEqual(category.rawValue)
                })
                
                let priorityMatch = selectedFilterPriorities.isEmpty || selectedFilterPriorities.contains(where: { priority in
                    task.taskPriority.elementsEqual(priority.rawValue)
                })
                
                let calendar = Calendar.current
                let fromDateStartOfDay = calendar.startOfDay(for: fromDate)
                let toDateEndOfDay = calendar.startOfDay(for: toDate).addingTimeInterval(24*60*60 - 1) 
                let taskDateStartOfDay = calendar.startOfDay(for: task.dueDate)
                
                let fromDateMatch = !fromDateToggle || (taskDateStartOfDay >= fromDateStartOfDay)
                let toDateMatch = !toDateToggle || (taskDateStartOfDay <= toDateEndOfDay)
                
                let statusMatch: Bool
                switch taskStatus {
                case .done:
                    statusMatch = task.done
                case .unDone:
                    statusMatch = !task.done
                case .all:
                    statusMatch = true
                }
                
                return categoryMatch && priorityMatch && fromDateMatch && toDateMatch && statusMatch
            }
        }
    }
    
    func deleteEntry(for key: String) {
        tasks.removeValue(forKey: key)
    }
    
    func updateEntry(for key: String, with task: TaskObject) {
        tasks[key] = task
        isUpdated = true
    }
    
    func addNotification(for task: TaskObject) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Task Reminder"
            
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: task.dueDate)
            components.hour = 7
            components.minute = 0
            
            let currentHour = calendar.component(.hour, from: Date())
            
            if task.dueDate < calendar.startOfDay(for: Date()) {
                content.body = "Your task '\(task.taskName)' is overdue."
                content.sound = UNNotificationSound.default
            } else {
                content.body = "Your task '\(task.taskName)' is expiring today."
                content.sound = UNNotificationSound.default
            }

            if components.hour ?? 7 < currentHour {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
                center.add(request)
            } else {
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
                center.add(request)
            }
            
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Failed to give notification permission")
                    }
                }
            }
        }
    }
    
    func checkTasksForToday() {
        let today = Calendar.current.startOfDay(for: Date())

        for task in tasks.values {
            let startOfDayForTask = Calendar.current.startOfDay(for: task.dueDate)

            if (Calendar.current.isDate(startOfDayForTask, inSameDayAs: today) || startOfDayForTask < today) && !task.done {
                addNotification(for: task)
            }
        }
    }
    
}
