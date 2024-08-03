//
//  LoginView.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var error: [Bool] = [false, false]
    @State var loginAction: Bool = false
    @State var showDialog: Bool = false
    @State var isFieldFocused: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("Task\nManager")
                    .multilineTextAlignment(.center)
                    .font(.custom("Inter", size: 48))
                    .foregroundStyle(Color.black.gradient.opacity(0.7))
                    .padding(.bottom, 150)
                
                
                TaskTextfield(text: $username, placeholder: "username", title: "", validators: [Validations.isUsernameValid], error: $error[0], isFocused: isFieldFocused, style: .bordered)
                    .padding(.horizontal, 20)
                
                TaskTextfield(text: $password,placeholder: "password", title: "", validators: [Validations.isPasswordValid], error: $error[1], style: .borderedSecure)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Button {
                    if  !error.contains(true) {
                        loginAction = true
                    } else {
                        showDialog = true
                    }
                } label: {
                    Text("Login")
                        .frame(width: 150, height: 50)
                        .font(.custom("Inter", size: 18))
                        .foregroundStyle(Color.white.gradient.opacity(0.8))
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.gradient.opacity(0.8)))
                        .padding(.bottom, 100)
                        .opacity(!username.isEmpty && !password.isEmpty ? 1 : 0.5)
                        .disabled((!username.isEmpty && !password.isEmpty ? false : true))
                }
                
            }
            .navigationDestination(isPresented: $loginAction) {
                MainView()
            }
            .alert(isPresented: $showDialog) {
                Alert(title: Text("Try again"), message: Text("Wrong Credentials!"), dismissButton: .default(Text("OK")))
            }
            
            .background(
                LinearGradient(colors: [Color.black.opacity(0.4),Color.white.opacity(0.5), Color.black.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .background(
                LinearGradient(colors: [Color.black.opacity(0.4),Color.white.opacity(0.5), Color.black.opacity(0.4)], startPoint: .topTrailing, endPoint: .bottomLeading)
            )
        }
        
    }
}

#Preview {
    LoginView()
}
