# GreekSMS

Course: CPSC-357 
Assignment: Final Project
Professor: Franceli
Students: Tyler Zastrow & Cody Wellington 
Student IDs: 240762 & 2377294
Emails: zastrow@chapman.edu & wellington@chapman.edu

This IOS application seeks to provide an enhanced way for fraternities and sororites to communicate. There are a few functionality applications that need to be added before the application can be pushed to the app store. 

Please allow ample time for the application to open and load as it must download some package dependencies. It will download these on their own but just takes time. 

Codefile Overview:

Code Components:

greeksmsApp.swift: Main app entry point, setting up the app's initial view and managing the app delegate.
ContactsViewModel.swift: Manages contacts and groups, interfacing with Firestore to fetch and update data.
ContactCardView.swift: Displays contact details and provides editing functionality.
CustomizeHomeScreenView.swift: Allows users to customize the home screen by adding quick message buttons.
HomeViewModel.swift: Manages quick message buttons and handles saving/loading them from UserDefaults.
ContactGroupSelectorView.swift: UI for selecting recipients for a new message.
MessageLogView.swift: Displays a log of sent messages (placeholder as of now).
User.swift: Model class for user details.
ContentView.swift: Displays a greeting message or checks the user status.
NewMessageView.swift: UI for composing and sending new messages.
SettingsView.swift: Displays user settings and provides sign-out functionality.
ContactsView.swift: Manages and displays contacts and groups.
SignInView.swift: UI for signing in users.
HomePage.swift: Main home screen UI, integrating all components and providing navigation.
SendSMS.swift: Handles sending SMS through Twilio API.
AuthenticationViewModel.swift: Manages user authentication state.
