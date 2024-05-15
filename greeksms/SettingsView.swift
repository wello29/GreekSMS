//
//  SettingsView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/9/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Profile")
                .font(.headline)
                .padding()
            
            if let user = authViewModel.currentUser {
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(user.name)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            Spacer()
            
            Button("Sign Out") {
                authViewModel.signOut()
            }
            .foregroundColor(.red)
            .padding()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

