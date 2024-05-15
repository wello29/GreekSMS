//
//  HomePage.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/7/24.
//

//
//import SwiftUI
//
//// Custom colors and styles extension
//extension Color {
//    static let customSecondary = Color(red: 248 / 255, green: 57 / 255, blue: 68 / 255)
//}
//
//struct HomePage: View {
//    @EnvironmentObject var authViewModel: AuthenticationViewModel
//    @State private var showingNewMessage = false
//    @State private var selectedTab: Int = 0
//    @StateObject var homeViewModel = HomeViewModel()
//    @StateObject var contactsViewModel: ContactsViewModel
//
//    init(authViewModel: AuthenticationViewModel) {
//        _contactsViewModel = StateObject(wrappedValue: ContactsViewModel(user: authViewModel.currentUser!))
//    }
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            NavigationView {
//                ScrollView {
//                    VStack(spacing: 20) {
//                        // Greeting Tile
//                        TileView(
//                            title: "Hi there, \(authViewModel.currentUser?.name ?? "User")",
//                            subtitle: "Welcome Back!",
//                            icon: "person.circle.fill",
//                            backgroundColor: Color.blue.opacity(0.9),
//                            spanTwoColumns: true
//                        )
//
//                        // Contacts and Folders Tiles
//                        HStack(spacing: 10) {
//                            TileView(
//                                title: "\(contactsViewModel.contacts.count)",
//                                subtitle: "Contacts",
//                                icon: "person.3.fill",
//                                backgroundColor: Color.green
//                            )
//
//                            TileView(
//                                title: "\(contactsViewModel.groups.count)",
//                                subtitle: "Folders",
//                                icon: "folder",
//                                backgroundColor: Color.orange
//                            )
//                        }
//
//                        // Quick Message Buttons
//                        ForEach(homeViewModel.quickMessageButtons) { button in
//                            TileView(
//                                title: button.title,
//                                subtitle: button.subtitle,
//                                backgroundColor: button.color,
//                                action: {
//                                    launchNewMessageView(groupID: button.groupID)
//                                }
//                            )
//                        }
//
//                        // Customize Button
//                        Button("Customize Home Screen") {
//                            homeViewModel.showingCustomizeScreen = true
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.customSecondary)
//                        .cornerRadius(10)
//                        .foregroundColor(.white)
//                    }
//                    .padding()
//                }
//                .navigationTitle("Home")
//                .sheet(isPresented: $homeViewModel.showingCustomizeScreen) {
//                    CustomizeHomeScreenView(viewModel: homeViewModel, contactsViewModel: contactsViewModel)
//                }
//            }
//            .tabItem {
//                Label("Home", systemImage: "house.fill")
//            }
//            .tag(0)
//
//            MessageLogView()
//                .tabItem {
//                    Label("Messages", systemImage: "envelope.fill")
//                }
//                .tag(1)
//
//            Button(action: {
//                showingNewMessage = true
//            }) {
//                Image(systemName: "plus.circle.fill")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .foregroundColor(.blue)
//                    .frame(width: 55, height: 55)
//                    .background(Color.customSecondary)
//                    .clipShape(Circle())
//            }
//            .sheet(isPresented: $showingNewMessage) {
//                if let user = authViewModel.currentUser {
//                    NewMessageView(isPresented: $showingNewMessage)
//                        .environmentObject(user)
//                        .environmentObject(contactsViewModel)
//                }
//            }
//            .tabItem {
//                Label("New Message", systemImage: "plus.circle.fill")
//            }
//            .tag(2)
//
//            ContactsView(viewModel: contactsViewModel)
//                .tabItem {
//                    Label("Contacts", systemImage: "person.3.fill")
//                }
//                .tag(3)
//
//            SettingsView()
//                .environmentObject(authViewModel)
//                .tabItem {
//                    Label("Settings", systemImage: "gearshape.fill")
//                }
//                .tag(4)
//        }
//        .accentColor(.customSecondary)
//        .environmentObject(contactsViewModel)
//        .onAppear {
//            authViewModel.fetchUserDetails()
//        }
//    }
//
//    private func launchNewMessageView(groupID: String) {
//        showingNewMessage = true
//        // Implement launching NewMessageView with the group pre-selected
//    }
//}
//
//// TileView for each tile on the homepage
//struct TileView: View {
//    var title: String
//    var subtitle: String
//    var icon: String? = nil
//    var backgroundColor: Color = Color.blue
//    var spanTwoColumns: Bool = false
//    var action: (() -> Void)? = nil
//
//    var body: some View {
//        Button(action: {
//            action?()
//        }) {
//            VStack(alignment: .leading, spacing: 8) {
//                if let icon = icon {
//                    Image(systemName: icon)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(.white)
//                }
//                Text(title)
//                    .font(.title)
//                    .bold()
//                    .foregroundColor(.white)
//                Text(subtitle)
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.8))
//            }
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
//            .background(backgroundColor)
//            .cornerRadius(15)
//        }
//        .frame(maxWidth: spanTwoColumns ? .infinity : nil)
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
import SwiftUI

extension Color {
    static let customSecondary = Color(red: 248 / 255, green: 57 / 255, blue: 68 / 255)
}

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showingNewMessage = false
    @State private var selectedTab: Int = 0
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var contactsViewModel: ContactsViewModel
    
    init(authViewModel: AuthenticationViewModel) {
        _contactsViewModel = StateObject(wrappedValue: ContactsViewModel(user: authViewModel.currentUser!))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Greeting Tile
                        Button(action: {
                            selectedTab = 4 // Navigate to Settings tab
                        }) {
                            TileView(
                                title: "Hi there, \(authViewModel.currentUser?.name ?? "User")",
                                subtitle: "Welcome Back!",
                                icon: "person.circle.fill",
                                backgroundColor: Color.blue.opacity(0.9),
                                spanTwoColumns: true
                            )
                        }
                        
                        // Contacts and Folders Tiles
                        HStack(spacing: 10) {
                            Button(action: {
                                selectedTab = 3 // Navigate to Contacts tab
                                contactsViewModel.selectedTab = 0 // All Contacts tab
                            }) {
                                TileView(
                                    title: "\(contactsViewModel.contacts.count)",
                                    subtitle: "Contacts",
                                    icon: "person.3.fill",
                                    backgroundColor: Color.green
                                )
                            }
                            Button(action: {
                                selectedTab = 3 // Navigate to Contacts tab
                                contactsViewModel.selectedTab = 1 // Folders tab
                            }) {
                                TileView(
                                    title: "\(contactsViewModel.groups.count)",
                                    subtitle: "Folders",
                                    icon: "folder",
                                    backgroundColor: Color.orange
                                )
                            }
                        }
                        
                        // Quick Message Buttons
                        ForEach(homeViewModel.quickMessageButtons) { button in
                            TileView(
                                title: button.title,
                                subtitle: button.subtitle,
                                backgroundColor: button.color,
                                action: {
                                    launchNewMessageView(groupID: button.groupID)
                                }
                            )
                        }
                    }
                    .padding()
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Customize Home Screen") {
                                homeViewModel.showingCustomizeScreen = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
                .sheet(isPresented: $homeViewModel.showingCustomizeScreen) {
                    CustomizeHomeScreenView(viewModel: homeViewModel, contactsViewModel: contactsViewModel)
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            MessageLogView()
                .tabItem {
                    Label("Messages", systemImage: "envelope.fill")
                }
                .tag(1)
            
            Button(action: {
                showingNewMessage = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.blue)
                    .frame(width: 55, height: 55)
                    .background(Color.customSecondary)
                    .clipShape(Circle())
            }
            .sheet(isPresented: $showingNewMessage) {
                if let user = authViewModel.currentUser {
                    NewMessageView(isPresented: $showingNewMessage)
                        .environmentObject(user)
                        .environmentObject(contactsViewModel)
                }
            }
            .tabItem {
                Label("New Message", systemImage: "plus.circle.fill")
            }
            .tag(2)
            
            ContactsView(viewModel: contactsViewModel)
                .tabItem {
                    Label("Contacts", systemImage: "person.3.fill")
                }
                .tag(3)
            
            SettingsView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .accentColor(.customSecondary)
        .environmentObject(contactsViewModel)
        .onAppear {
            authViewModel.fetchUserDetails()
        }
    }
    
    private func launchNewMessageView(groupID: String) {
        showingNewMessage = true
        // Implement launching NewMessageView with the group pre-selected
    }
}

// TileView for each tile on the homepage
struct TileView: View {
    var title: String
    var subtitle: String
    var icon: String? = nil
    var backgroundColor: Color = Color.blue
    var spanTwoColumns: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(15)
        }
        .frame(maxWidth: spanTwoColumns ? .infinity : nil)
        .buttonStyle(PlainButtonStyle())
    }
}
