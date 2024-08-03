//
//  TaskTextfield.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import SwiftUI

struct TaskTextfield: View {
    
    @Binding var text: String
    @Binding var error: Bool
    @Binding var showError: Bool
    @State var placeholder: String
    @State var title: String
    
    @State var style: TextFieldStyle
    @State var showPass: Bool = false
    @FocusState var isFocused: Bool
    
    var validators: [(String) -> Bool]?
    init(text: Binding<String>,
         placeholder: String = "type here...",
         title: String,
         validators: [(String) -> Bool ]? = nil,
         showError: Binding<Bool> = .constant(false),
         error: Binding<Bool> = .constant(false),
         isFocused: Bool = false,
         style: TextFieldStyle = .bordered) {
        _text = text
        _error = error
        _showError = showError
        self.placeholder = placeholder
        self.title = title
        self.validators = validators
        
        self.style = style
        self.isFocused = isFocused
        
    }
    var body: some View {
        
        switch style {
        case .bordered:
            borderedTextField
        case .borderedSecure:
            borderedSecureTextField
        case .underline:
            underlineTextField
        case .undelineSecure:
            underlineSecureTextField
        }
        
    }
    
    private var borderedTextField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Inter", size: 16))
            
            TextField(placeholder, text: $text)
                .padding()
                .font(.custom("Inter", size: 16))
                .overlay{RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 1).foregroundStyle(showError ? Color.red.gradient.opacity(0.8) : Color.black.gradient.opacity(isFocused ? 1 : 0.4))}
                .textInputAutocapitalization(.never)
                .focused($isFocused)
        }
        .onChange(of: text) {
            error = !validateText()
        }
        .onChange(of: isFocused){
            
            if !isFocused {
                showError = !validateText()
            }
        }
    }
    
    private var borderedSecureTextField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Inter", size: 16))
            HStack {
                if showPass {
                    TextField(placeholder, text: $text)
                        .padding()
                        .font(.custom("Inter", size: 16))
                    
                } else {
                    SecureField(placeholder, text: $text)
                        .padding()
                        .font(.custom("Inter", size: 16))
                }
                
                Button {
                    withAnimation(.bouncy.speed(2)) {
                        showPass.toggle()
                    }
                    
                }label: {
                    Image(systemName: showPass ? "eye.slash" : "eye")
                        .renderingMode(.template)
                        .foregroundStyle(Color.black.gradient.opacity(0.5))
                        .padding(.horizontal, 10)
                }
                
                
            }
            .overlay{RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 1)
                    .foregroundStyle(Color.black.gradient
                        .opacity(isFocused ? 1 : 0.4))}
            .textInputAutocapitalization(.never)
            .focused($isFocused)
        }
        .onChange(of: text) {
            
            error = !validateText()
        }
    }
    
    private var underlineTextField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Inter", size: 16))
            
            TextField(placeholder, text: $text)
                .padding(.vertical, 5)
                .font(.custom("Inter", size: 16))
                .textInputAutocapitalization(.never)
                .focused($isFocused)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(showError ? Color.red.gradient.opacity(0.8) : Color.black.gradient.opacity(isFocused ? 1 : 0.4))
        }
        .onChange(of: text) {
            error = !validateText()
        }
        .onChange(of: isFocused){
            
            if !isFocused {
                showError = !validateText()
            }
        }
    }
    
    private var underlineSecureTextField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Inter", size: 16))
            HStack {
                if showPass {
                    TextField(placeholder, text: $text)
                        .padding(.vertical, 5)
                        .font(.custom("Inter", size: 16))
                    
                } else {
                    SecureField(placeholder, text: $text)
                        .padding(.vertical, 5)
                        .font(.custom("Inter", size: 16))
                }
                
                Button {
                    withAnimation(.bouncy.speed(2)) {
                        showPass.toggle()
                    }
                    
                }label: {
                    Image(systemName: showPass ? "eye.slash" : "eye")
                        .renderingMode(.template)
                        .foregroundStyle(Color.black.gradient.opacity(0.5))
                        .padding(.horizontal, 10)
                }
                
                
            }
            .textInputAutocapitalization(.never)
            .focused($isFocused)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.black.gradient.opacity(isFocused ? 1 : 0.4))
        }
        .onChange(of: text) {
            
            error = !validateText()
        }
    }
    
    func validateText() -> Bool {
        
        var isValid: Bool = true
        
        if !text.isEmpty {
            
            if let validators = validators {
                
                for validator in validators {
                    switch validator(text) {
                    case true:
                        isValid = true
                    case false:
                        isValid = false
                    }
                }
                return isValid
            }
        }
        return true
    }
}

#Preview {
    TaskTextfield(text: .constant(""), placeholder: "type here...", title: "username", isFocused: true, style: .underline)
}
