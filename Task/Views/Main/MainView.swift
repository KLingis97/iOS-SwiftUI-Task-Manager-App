//
//  MainView.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var vm = MainViewVM.init()
    @State var showAddNewSheet: Bool = false
    @State var goToTask: Bool = false
    @State var selectedTask: TaskObject = TaskObject(taskName: "", taskDescription: "", taskPriority: FilterPriority.normal.rawValue, dueDate: Date.now, taskCategory: FilterCategory.other.rawValue, done: false)
    @State var showFilters: Bool = false
    @State var showSearchBar: Bool = false
    @State var markAsDone: Bool = false
    @State var searchText: String = ""
    var searchResults: [String: TaskObject] {
        if searchText.isEmpty {
            return vm.tasks
        } else {
            return vm.tasks.filter { $0.value.taskName.localizedCaseInsensitiveContains(searchText) || $0.value.taskCategory.localizedCaseInsensitiveContains(searchText) || $0.value.taskDescription.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        
        NavigationStack {
            HStack{
                TextField(" Search...", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .padding(7)
                    .background(Color.gray.gradient.opacity(0.2))
                    .cornerRadius(20)
                
                
                Button {
                    showFilters = true
                } label: {
                    Image(systemName: "slider.vertical.3")
                        .foregroundStyle(Color.black.gradient.opacity(0.8))
                }
                .frame(width: 15, height: 15)
                .padding(.leading, 5)
                
                
            }
            .padding(.horizontal)
            
            ScrollView {
                
                LazyVStack(spacing: 5) {
                    
                    ForEach(vm.keysToDisplay(for: searchResults), id: \.self) { key in
                        
                        if let taskBinding = Binding($vm.tasks[key]) {
                            TaskView(
                                task: taskBinding,
                                selectedTask: $selectedTask,
                                goToTask: $goToTask,
                                markAsDone: taskBinding.done,
                                updateTask: { task in
                                    vm.updateEntry(for: task.id.uuidString, with: task)
                                },
                                deleteTask: { task in
                                    vm.deleteEntry(for: task.id.uuidString)
                                }
                            )
                            .padding(.horizontal)
                            .padding(.top, 5)
                        }
                        
                    }
                }
                .scrollTargetLayout()
                
            }
            .scrollTargetBehavior(.viewAligned)
            .overlay(alignment: .bottom){
                
                Spacer()
                Button {
                    showAddNewSheet = true
                } label: {
                    Image(systemName: "plus")
                        .padding(10)
                        .foregroundStyle(Color.white.gradient.opacity(0.8))
                        .background(Circle().fill(Color.black.gradient.opacity(0.75)))
                }
                
            }
            .navigationTitle("Task Manager")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    
                    
                    
                })
                
            }
            .background(
                LinearGradient(colors: [Color.black.opacity(0.5),Color.white.opacity(0.1)], startPoint: .bottom, endPoint: .top)
            )
        }
        .fullScreenCover(isPresented: $goToTask, onDismiss: {
            goToTask = false
        }){
            EditTaskView(task: $selectedTask, vm: vm, save: { task in
                vm.updateEntry(for: task.id.uuidString, with: task)
            },delete: { task in
                vm.deleteEntry(for: task.id.uuidString)
            })
        }
        .sheet(isPresented: $showAddNewSheet, onDismiss: {
            showAddNewSheet = false
        }) {
            AddNewSheet(showSheet: $showAddNewSheet, save: { task in
                vm.tasks[task.id.uuidString] = task
            })
            .presentationDetents([.height(580),.fraction(0.750)])
        }
        .sheet(isPresented: $showFilters, onDismiss: {
            showFilters = false
        }) {
            
            FilterView(showFilters: $showFilters,fromDate: $vm.fromDate,toDate: $vm.toDate,fromDateToggle: $vm.fromDateToggle,toDateToggle: $vm.toDateToggle, selectedFilterCategories: $vm.selectedFilterCategories, selectedFilterPriorities: $vm.selectedFilterPriorities, sortingDescending: $vm.sortingDescending, rotationArrow: $vm.rotationArrow, selectedSorting: $vm.selectedSorting, status: $vm.taskStatus)
                .presentationDetents([.height(650),.fraction(0.850)])
        }
        .navigationBarBackButtonHidden()
        
        
    }
}

#Preview {
    MainView()
}
