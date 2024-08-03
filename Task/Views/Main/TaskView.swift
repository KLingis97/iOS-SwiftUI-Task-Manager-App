//
//  TaskView.swift
//  Task
//
//  Created by Kyriakos Lingis on 16/11/2023.
//

import SwiftUI

struct TaskView: View {
    @Binding var task: TaskObject
    @State var key: String = ""
    @Binding var selectedTask: TaskObject
    @Binding var goToTask: Bool
    @Binding var markAsDone: Bool
    var updateTask: ((TaskObject)->())?
    var deleteTask: ((TaskObject)->())?
    
    var body: some View {
        
        Button {
            selectedTask = task
            
            goToTask = true
        } label: {
            HStack {
                Text(task.taskName )
                    .padding(.trailing, 5)
                
                Spacer()
                
                Text(task.dueDate.formatted(.dateTime.day().month().year()))
                
                Spacer()
                
                Text(task.taskCategory)
                
                Spacer()
                
                Text(task.taskPriority)
                
                Image(systemName: task.taskPriority == FilterPriority.low.rawValue ? "chevron.compact.left" : task.taskPriority == FilterPriority.normal.rawValue ? "chevron.left" : "chevron.left.2")
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: 12, height: 12)
                
                
            }
            .multilineTextAlignment(.leading)
            .font(.custom("Inter", size: 13))
            .foregroundStyle(Color.white.gradient.opacity(0.8))
            .fixedSize(horizontal: false, vertical: true)
        }
        .onAppear {
            markAsDone = task.done
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).fill(markAsDone ? Color.gray.gradient.opacity(0.5) : Color.black.gradient.opacity(0.8)).shadow(radius: 5))
        
        .contextMenu {
            Button {
                markAsDone.toggle()
                task.done = markAsDone
                selectedTask = task
                updateTask?(selectedTask)
            } label: {
                Text("Mark as \(markAsDone ? "Incomplete" : "Completed")")
            }
            
            Button {
                selectedTask = task
                deleteTask?(selectedTask)
            } label: {
                Text("Delete")
            }
        }
    }
}

#Preview {
    TaskView(task: .constant(TaskObject(taskName: "", taskDescription: "", taskPriority: FilterPriority.low.rawValue, dueDate: .now, taskCategory: FilterCategory.other.rawValue, done: false)), selectedTask: .constant(TaskObject(taskName: "", taskDescription: "", taskPriority: FilterPriority.low.rawValue, dueDate: .now, taskCategory: FilterCategory.other.rawValue, done: false)), goToTask: .constant(false), markAsDone: .constant(false))
}
