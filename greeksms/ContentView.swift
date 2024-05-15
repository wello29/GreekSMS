//
//  ContentView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/6/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel


    var body: some View {
        VStack {
            // Use the entire screen's height minus safe area insets
            Spacer()
            
            if let user = authViewModel.currentUser {
                // Display the user's name in a large, bold font
                Text("Hi there, \(user.name)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary) // Adapts to dark/light mode
                    .padding(.top, 1)// Add padding around the text for better spacing
                
            } else {
                // If no user is logged in, prompt to check the login status
                Text("Checking user status...")
                    .foregroundColor(.secondary)
                    .font(.title)
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all) // Extend the background color to the edges
    }
}

