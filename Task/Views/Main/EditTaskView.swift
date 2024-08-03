//
//  EditTaskView.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var task: TaskObject
    @State var showEmptyError: Bool = false
    @State var selectedPriority: FilterPriority = .normal
    @State var selectedCategory: FilterCategory = .other
    @State var showAlert: Bool = false
    @State var markAsDone: Bool = false
    @ObservedObject var vm: MainViewVM
    var save: ((TaskObject)->Void)?
    var delete: ((TaskObject)->Void)?
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Text("Edit task")
                    .font(.custom("Inter", size: 25))
                    .fontWeight(.bold)
                
                Spacer()
                
                TaskTextfield(text: $task.taskName, placeholder: "task name", title: "", showError: $showEmptyError, style: .underline)
                    .font(.custom("Inter", size: 15))
                    .foregroundStyle(Color.black.gradient.opacity(0.8))
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
                
                HStack {
                    Text("Task status:")
                        .font(.custom("Inter", size: 16))
                        .foregroundStyle(Color.black.gradient.opacity(0.8))
                    
                    Spacer()
                    Button {
                        withAnimation(.bouncy.speed(2)) {
                            markAsDone.toggle()
                        }
                    } label: {
                        Text(markAsDone ? FilterStatus.done.rawValue : FilterStatus.unDone.rawValue )
                            .font(.custom("Inter", size: 15))
                            .foregroundStyle(Color.black.gradient.opacity(0.8))
                        
                        Image(systemName: markAsDone ? "checkmark.circle" : "xmark.circle")
                            .renderingMode(.template)
                            .foregroundStyle(markAsDone ? Color.green.gradient.opacity(0.8) : Color.red.gradient.opacity(0.8))
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        showAlert = true
                    } label: {
                        Text("Delete")
                            .frame(width: 150, height: 50)
                            .font(.custom("Inter", size: 18))
                            .foregroundStyle(Color.red.gradient.opacity(0.8))
                            .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.gradient.opacity(0.8)))
                    }
                    Spacer()
                    Button {
                        if !task.taskName.isEmpty {
                            task.taskPriority = selectedPriority.rawValue
                            task.taskCategory = selectedCategory.rawValue
                            task.done = markAsDone
                            save?(task)
                            dismiss()
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
                    Spacer()
                }
                Spacer()
                
            }
            .font(.custom("Inter", size: 16))
            .foregroundStyle(Color.black.gradient.opacity(1))
            .padding(.horizontal)
        }
        .onAppear {
            selectedCategory = FilterCategory(rawValue: task.taskCategory) ?? .other
            selectedPriority = FilterPriority(rawValue: task.taskPriority) ?? .normal
            markAsDone = task.done
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Caution"), message: Text("Are you sure you want to delete this task?"), primaryButton: .default(Text("No")),
                  secondaryButton: .destructive(Text("Yes"), action: { delete?(task); dismiss() }))
        }
    }
}

#Preview {
    EditTaskView(task: .constant(TaskObject(id: UUID(), taskName: "", taskDescription: "", taskPriority: FilterPriority.normal.rawValue, dueDate: Date.now, taskCategory: FilterCategory.other.rawValue, done: false)), vm: MainViewVM())
}
