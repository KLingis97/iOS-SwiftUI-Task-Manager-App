//
//  AddNewSheet.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import SwiftUI

struct AddNewSheet: View {
    @State var task: TaskObject = TaskObject(id: UUID(), taskName: "", taskDescription: "", taskPriority: FilterPriority.normal.rawValue, dueDate: Date.now, taskCategory: FilterCategory.other.rawValue, done: false)
    @State var selectedPriority: FilterPriority = .normal
    @State var selectedCategory: FilterCategory = .other
    @State var showEmptyError: Bool = false
    @Binding var showSheet: Bool
    
    var save: ((TaskObject)->Void)?
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    showSheet = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
            
            
            Text("Add new task")
                .font(.custom("Inter", size: 25))
                .fontWeight(.bold)
            
            TaskTextfield(text: $task.taskName, placeholder: "task name", title: "", showError: $showEmptyError, style: .underline)
                .font(.custom("Inter", size: 15))
                .foregroundStyle(showEmptyError ? Color.red.gradient.opacity(0.8) : Color.black.gradient.opacity(0.8))
                .padding(.horizontal)
                .padding(.vertical, 5)
                .onTapGesture {
                    showEmptyError = false
                }
            
            
            HStack{
                Text("Due date")
                    .font(.custom("Inter", size: 16))
                    .foregroundStyle(Color.black.gradient.opacity(0.8))
                Spacer()
                DatePicker("", selection: $task.dueDate,in: Date.now... , displayedComponents: .date)
                    .datePickerStyle(.compact)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            VStack(alignment: .leading){
                Text("Priority:")
                    .font(.custom("Inter", size: 16))
                    .foregroundStyle(Color.black.gradient.opacity(0.8))
                Picker("", selection: $selectedPriority) {
                    ForEach(FilterPriority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            VStack(alignment: .leading){
                Text("Category:")
                    .font(.custom("Inter", size: 16))
                    .foregroundStyle(Color.black.gradient.opacity(0.8))
                Picker("", selection: $selectedCategory) {
                    ForEach(FilterCategory.allCases, id: \.self) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            VStack(alignment: .leading) {
                Text("Description :")
                    .font(.custom("Inter", size: 16))
                    .foregroundStyle(Color.black.gradient.opacity(0.8))
                TextEditor(text: $task.taskDescription)
                    .frame(maxHeight: 100)
                    .font(.custom("Inter", size: 15))
                    .foregroundStyle(Color.black.gradient.opacity(0.8))
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 2).foregroundStyle(Color.gray.gradient.opacity(0.2))
                    }
                
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Button {
                if !task.taskName.isEmpty {
                    task.taskPriority = selectedPriority.rawValue
                    task.taskCategory = selectedCategory.rawValue
                    save?(task)
                    showSheet = false
                } else {
                    showEmptyError = true
                }
            } label: {
                Text("Save")
                    .frame(width: 150, height: 50)
                    .font(.custom("Inter", size: 18))
                    .foregroundStyle(Color.white.gradient.opacity(0.8))
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.gradient.opacity(0.8)))
            }
            
        }
        .font(.custom("Inter", size: 16))
        .foregroundStyle(Color.black.gradient.opacity(1))
        .padding(.horizontal)
    }
}

#Preview {
    AddNewSheet(showSheet: .constant(true))
}
