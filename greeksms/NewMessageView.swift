//
//  NewMessageView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/9/24.
//
//



import SwiftUI
import AVFoundation

struct NewMessageView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var user: User
    @EnvironmentObject var contactsViewModel: ContactsViewModel

    @State private var showingSelector = false
    @State private var selectedGroup: SMSGroup?
    @State private var selectedRecipients: [String] = []
    @State private var messageBody: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Group Selector
                Button(action: {
                    showingSelector = true
                }) {
                    HStack {
                        Text("To:")
                        Text(selectedGroup?.name ?? "Select Group")
                            .foregroundColor(.gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary))
                }
                .padding()

                // From (Read-Only)
                TextField("From:", text: Binding.constant("From \(user.phoneNumber)"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(true)

                // Message Editor
                TextEditor(text: $messageBody)
                    .frame(minHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                    .padding()

                Spacer()
            }
            .navigationTitle("New Message")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Send") {
                sendGroupMessage()
            })
            .sheet(isPresented: $showingSelector) {
                ContactGroupSelectorView(
                    isPresented: $showingSelector,
                    selectedGroup: $selectedGroup,
                    selectedRecipients: $selectedRecipients,
                    viewModel: contactsViewModel
                )
            }
        }
    }

    private func sendGroupMessage() {
        if selectedRecipients.isEmpty {
            print("Error: No recipients selected")
            return
        }

        SMSManager.sendBulkSMS(user: user, toRecipients: selectedRecipients, messageBody: messageBody) { success, error in
            if success {
                playSentSound()
                isPresented = false
            } else {
                print("Failed to send message: \(String(describing: error))")
            }
        }
    }

    private func playSentSound() {
        let systemSoundID: SystemSoundID = 1001
        AudioServicesPlaySystemSound(systemSoundID)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}


