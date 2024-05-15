//
//  ContactCardView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/4/24.
//

import Foundation
import SwiftUI

struct ContactCardView: View {
    @ObservedObject var viewModel: ContactsViewModel
    @Binding var contact: SMSContact
    @State private var isEditing = false
    @State private var showingFolderPicker = false
    @Environment(\.presentationMode) var presentationMode  // Used to dismiss the view
    
    var body: some View {
        VStack {
            // Title and close button
            HStack {
                Text("Contact Card")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.customSecondary)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)

            Spacer(minLength: 30)

            // Contact details or edit view
            if isEditing {
                EditContactView(contact: $contact, onSave: { updatedContact in
                    viewModel.updateContact(updatedContact)
                    isEditing = false  // Dismiss edit view
                })
                .padding(.horizontal)
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Name:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(contact.name)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 1))

                    HStack {
                        Text("Phone:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(contact.phoneNumber)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 1))
                }
                .padding(.horizontal)

                Spacer(minLength: 20)

                // Edit and Change Folder buttons
                VStack(spacing: 15) {
                    Button(action: {
                        isEditing = true
                    }) {
                        Text("Edit")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.customSecondary)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        showingFolderPicker = true
                    }) {
                        Text("Change Folder")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.customSecondary)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .actionSheet(isPresented: $showingFolderPicker) {
                    ActionSheet(title: Text("Select Folder"), buttons: actionSheetButtons())
                }
                .padding(.bottom, 30)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 5))
        .padding(.horizontal, 20)
        .padding(.vertical, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Contact Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    func actionSheetButtons() -> [ActionSheet.Button] {
        var buttons = [ActionSheet.Button]()

        for group in viewModel.groups {
            let isInGroup = group.contacts.contains(where: { $0.id == contact.id })
            let title = isInGroup ? "Remove from \(group.name)" : "Add to \(group.name)"
            let action: ActionSheet.Button = .default(Text(title)) {
                if isInGroup {
                    viewModel.removeContactFromGroup(contact: contact, group: group)
                } else {
                    viewModel.addContactToGroup(contact: contact, group: group)
                }
            }
            buttons.append(action)
        }

        buttons.append(.cancel())
        return buttons
    }
}

struct EditContactView: View {
    @Binding var contact: SMSContact
    var onSave: (SMSContact) -> Void

    @State private var localName: String
    @State private var localPhoneNumber: String

    init(contact: Binding<SMSContact>, onSave: @escaping (SMSContact) -> Void) {
        self._contact = contact
        self.onSave = onSave
        _localName = State(initialValue: contact.wrappedValue.name)
        _localPhoneNumber = State(initialValue: contact.wrappedValue.phoneNumber)
    }

    var body: some View {
        VStack {
            Text("Edit Contact")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            Form {
                Section {
                    TextField("Name", text: $localName)
                    TextField("Phone", text: $localPhoneNumber)
                }
            }

            Button("Save Changes") {
                var updatedContact = contact
                updatedContact.name = localName
                updatedContact.phoneNumber = localPhoneNumber
                onSave(updatedContact)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundColor(.white)
            .background(Color.customSecondary)
            .cornerRadius(10)
            .padding()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 1))
        .padding()
    }
}




