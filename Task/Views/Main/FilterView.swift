//
//  FilterView.swift
//  Task
//
//  Created by Kyriakos Lingis on 15/11/2023.
//

import SwiftUI

struct FilterView: View {
    
    @Binding var showFilters: Bool
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var fromDateToggle: Bool
    @Binding var toDateToggle: Bool
    @Binding var selectedFilterCategories: Set<FilterCategory>
    @Binding var selectedFilterPriorities: Set<FilterPriority>
    @Binding var sortingDescending: Bool
    @Binding var rotationArrow: Double
    @Binding var selectedSorting: String
    @Binding var status: FilterStatus
    @ObservedObject var vm = FilterViewVM()
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        VStack{
            HStack {
                Text("Filter by")
                    .font(.custom("Inter", size: 18))
                    .fontWeight(.bold)
                Spacer()
                
                Button {
                    showFilters = false
                }label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.black.gradient.opacity(0.8))
                }
                
            }
            
            Divider()
                .padding(.bottom)
            
            HStack{
                Text("Sort by ")
                    .font(Font.custom("Inter", size: 14).weight(.semibold))
                
                Image(systemName: "chevron.down")
                    .renderingMode(.template)
                    .foregroundStyle(Color.black.gradient.opacity(0.8))
                    .rotationEffect(.degrees(rotationArrow))
                    .onTapGesture {
                        withAnimation(Animation.bouncy.speed(2)) {
                            sortingDescending = sortingDescending == true ? false : true
                            rotationArrow += 180
                        }
                    }
                
                Spacer()
            }
            .padding(.bottom)
            
            VStack{
                HStack {
                    Button {
                        selectedSorting = Sorting.dueDate.rawValue
                    } label: {
                        HStack {
                            Circle().stroke(lineWidth: 2).foregroundStyle(Color.black.gradient.opacity(0.5)).frame(width: 20, height: 20)
                                .background{
                                    if selectedSorting == Sorting.dueDate.rawValue {
                                        Circle().fill(Color.black.gradient.opacity(0.7)).frame(width: 10, height: 10)
                                    }
                                }
                                .padding(.trailing, 5)
                            
                            Text("Due date")
                                .font(.custom("Inter", size: 14))
                        }
                        
                    }
                    Spacer()
                }
                
                HStack {
                    Button {
                        selectedSorting = Sorting.name.rawValue
                    } label: {
                        HStack {
                            Circle().stroke(lineWidth: 2).foregroundStyle(Color.black.gradient.opacity(0.5)).frame(width: 20, height: 20)
                                .background{
                                    if selectedSorting == Sorting.name.rawValue {
                                        Circle().fill(Color.black.gradient.opacity(0.7)).frame(width: 10, height: 10)
                                    }
                                }
                                .padding(.trailing, 5)
                            
                            Text("Name")
                                .font(.custom("Inter", size: 14))
                        }
                        
                    }
                    Spacer()
                }
                
                HStack {
                    Button {
                        selectedSorting = Sorting.category.rawValue
                    } label: {
                        HStack {
                            Circle().stroke(lineWidth: 2).foregroundStyle(Color.black.gradient.opacity(0.5)).frame(width: 20, height: 20)
                                .background{
                                    if selectedSorting == Sorting.category.rawValue {
                                        Circle().fill(Color.black.gradient.opacity(0.7)).frame(width: 10, height: 10)
                                    }
                                }
                                .padding(.trailing, 5)
                            
                            Text("Category")
                                .font(.custom("Inter", size: 14))
                        }
                        
                    }
                    Spacer()
                }
                
                HStack {
                    Button {
                        selectedSorting = Sorting.priority.rawValue
                    } label: {
                        HStack {
                            Circle().stroke(lineWidth: 2).foregroundStyle(Color.black.gradient.opacity(0.5)).frame(width: 20, height: 20)
                                .background{
                                    if selectedSorting == Sorting.priority.rawValue {
                                        Circle().fill(Color.black.gradient.opacity(0.7)).frame(width: 10, height: 10)
                                    }
                                }
                                .padding(.trailing, 5)
                            
                            Text("Priority")
                                .font(.custom("Inter", size: 14))
                        }
                        
                    }
                    Spacer()
                }
            }
            
            
            HStack{
                HStack {
                    Text("From:")
                        .font(.custom("Inter", size: 14))
                    DatePicker("", selection: $fromDate,in: Date.now... , displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .onChange(of: fromDate) {
                            if fromDateToggle && toDateToggle {
                                if fromDate > toDate {
                                    if let prevDay = Calendar.current.date(byAdding: .day, value: 1, to: fromDate) {
                                        toDate = prevDay
                                    }
                                    
                                }
                            }
                        }
                }
                .disabled(fromDateToggle ? false : true)
                .foregroundStyle(fromDateToggle ? Color.black.gradient.opacity(0.8) : Color.black.gradient.opacity(0.4) )
                
                withAnimation(.bouncy.speed(2)) {
                    Toggle("",isOn: $fromDateToggle)
                        .frame(width: 50)
                        .tint(Color.black.gradient.opacity(0.6))
                        .onChange(of: fromDateToggle) {
                            if fromDateToggle && toDateToggle {
                                if fromDate > toDate {
                                    if let prevDay = Calendar.current.date(byAdding: .day, value: -1, to: toDate) {
                                        fromDate = prevDay
                                    }
                                }
                            }
                        }
                }
                
            }
            .padding(.bottom)
            
            HStack{
                HStack {
                    Text("To:")
                        .font(.custom("Inter", size: 14))
                    DatePicker("", selection: $toDate,in: Date.now... , displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .onChange(of: toDate) {
                            if fromDateToggle && toDateToggle {
                                if toDate < fromDate {
                                    if let nextDay = Calendar.current.date(byAdding: .day, value: -1, to: toDate) {
                                        fromDate = nextDay
                                    }
                                    
                                }
                            }
                        }
                }
                .disabled(toDateToggle ? false : true)
                .foregroundStyle(toDateToggle ? Color.black.gradient.opacity(0.8) : Color.black.gradient.opacity(0.4) )
                
                withAnimation(.bouncy.speed(2)) {
                    Toggle("",isOn: $toDateToggle)
                        .frame(width: 50)
                        .tint(Color.black.gradient.opacity(0.6))
                        .onChange(of: toDateToggle) {
                            if fromDateToggle && toDateToggle {
                                if toDate < fromDate {
                                    if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: fromDate) {
                                        toDate = nextDay
                                    }
                                    
                                }
                            }
                        }
                }
                
                
            }
            .padding(.bottom)
            
            Text("Category")
                .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(FilterCategory.allCases, id: \.self) { category in
                    
                    Button(action: {
                        withAnimation(.bouncy.speed(2)){
                            selectedFilterCategories = vm.toggleCategory(category, in: selectedFilterCategories)
                        }
                    }) {
                        Text(category.rawValue)
                            .padding()
                            .font(.custom("Inter", size: 14))
                            .foregroundStyle(vm.isCategorySelected(category, in: selectedFilterCategories) ? Color.white.gradient.opacity(0.8) : Color.black.gradient.opacity(0.8))
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(vm.isCategorySelected(category, in: selectedFilterCategories) ? Color.black.gradient.opacity(0.8) : Color.clear.gradient.opacity(0.8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                            .stroke(Color.black.gradient.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(color: .gray, radius: 5)
                            )
                        
                    }
                }
            }
            
            Text("Priority")
                .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(FilterPriority.allCases, id: \.self) { priority in
                    
                    Button(action: {
                        withAnimation(.bouncy.speed(2)){
                            selectedFilterPriorities = vm.togglePriority(priority, in: selectedFilterPriorities)
                        }
                    }) {
                        HStack {
                            Text(String(priority.rawValue))
                                .font(.custom("Inter", size: 14))
                            Image(systemName: priority.rawValue == "Low" ? "chevron.compact.left" : priority.rawValue == "Normal" ? "chevron.left" : "chevron.left.2")
                                .rotationEffect(Angle(degrees: 90))
                                .foregroundStyle(vm.isPrioritySelected(priority, in: selectedFilterPriorities) ? Color.white.gradient.opacity(0.8) : Color.black.gradient.opacity(0.8))
                        }
                        .padding()
                        .foregroundStyle(vm.isPrioritySelected(priority, in: selectedFilterPriorities) ? Color.white.gradient.opacity(0.8) : Color.black.gradient.opacity(0.8))
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(vm.isPrioritySelected(priority, in: selectedFilterPriorities) ? Color.black.gradient.opacity(0.8) : Color.clear.gradient.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.black.gradient.opacity(0.5), lineWidth: 1)
                                )
                                .shadow(color: .gray, radius: 5)
                        )
                        
                    }
                }
            }
            .padding(.bottom, 10)
            
            Text("Task status")
                .padding(.bottom, 10)
            
            Picker("", selection: $status) {
                ForEach(FilterStatus.allCases, id: \.self) { status in
                    Text(status.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented) 
        }
        .font(.custom("Inter", size: 16))
        .foregroundStyle(Color.black.gradient.opacity(0.8))
        .padding(.horizontal)
    }
}

#Preview {
    FilterView(showFilters: .constant(true),fromDate: .constant(.now), toDate: .constant(.now),fromDateToggle: .constant(false), toDateToggle: .constant(false), selectedFilterCategories: .constant(Set()), selectedFilterPriorities: .constant(Set()), sortingDescending: .constant(true), rotationArrow: .constant(0.0), selectedSorting: .constant(Sorting.dueDate.rawValue), status: .constant(FilterStatus.done))
}
