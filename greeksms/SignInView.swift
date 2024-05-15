//
//  SignInView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/7/24.
//


import Foundation
import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            Image("message_style_logo")  // Ensure the logo image is named correctly in your assets
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .padding(.bottom, 0)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Sign In") {
                authViewModel.signIn(email: email, password: password)
            }
            .buttonStyle(CustomButtonStyle())
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

// Define a custom button style
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.customSecondary)  // Assuming `Color.customSecondary` is defined
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// Ensure to add the extension for your custom color if not already defined
//extension Color {
//    static let customSecondary = Color(red: 248 / 255, green: 57 / 255, blue: 68 / 255)
//}

