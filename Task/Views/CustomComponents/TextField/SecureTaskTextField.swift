//
//  SecureTaskTextField.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import SwiftUI

struct SecureTaskTextField: View {
    
    @Binding var text: String
    @Binding var error: Bool
    @State var placeholder: String
    @State var title: String
    @State var showPass: Bool = false
    @FocusState var isFocused: Bool
    
    var validators: [(String) -> Bool]?
    
    init(text: Binding<String>,
         placeholder: String = "type here...",
         title: String,
         validators: [(String) -> Bool ]? = nil,
         error: Binding<Bool> = .constant(false),
         isFocused: Bool = false) {
        
        _text = text
        _error = error
        self.placeholder = placeholder
        self.title = title
        self.validators = validators
        self.isFocused = isFocused
    }
    
    var body: some View {
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
            .overlay{RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 1).foregroundStyle(Color.black.gradient.opacity(isFocused ? 1 : 0.5))}
            .textInputAutocapitalization(.never)
            .focused($isFocused)
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
    SecureTaskTextField(text: .constant(""), placeholder: "type here...", title: "username")
}


