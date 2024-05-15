//
//  ContactGroupSelectorView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/5/24.
//


import SwiftUI

struct ContactGroupSelectorView: View {
    @Binding var isPresented: Bool
    @Binding var selectedGroup: SMSGroup?
    @Binding var selectedRecipients: [String]
    @ObservedObject var viewModel: ContactsViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Groups")) {
                    ForEach(viewModel.groups, id: \.id) { group in
                        Button(action: {
                            selectGroup(group: group)
                        }) {
                            HStack {
                                Text(group.name)
                                Spacer()
                                Image(systemName: selectedGroup?.id == group.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }

                Section(header: Text("Contacts")) {
                    ForEach(viewModel.contacts, id: \.id) { contact in
                        Button(action: {
                            toggleRecipient(contact.phoneNumber)
                        }) {
                            HStack {
                                Text(contact.name)
                                Spacer()
                                Image(systemName: selectedRecipients.contains(contact.phoneNumber) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Select Recipients")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }

    /// Selects a group and adds all contacts to `selectedRecipients`
    private func selectGroup(group: SMSGroup) {
        selectedGroup = group
        addGroupContacts(group: group)
        isPresented = false
    }

    /// Adds all contacts' phone numbers from the group to the `selectedRecipients`
    private func addGroupContacts(group: SMSGroup) {
        viewModel.fetchGroupContacts(groupID: group.id) { contacts in
            let phoneNumbers = contacts.map { $0.phoneNumber }
            let uniqueContacts = Set(phoneNumbers)
            selectedRecipients = Array(uniqueContacts)
        }
    }

    /// Toggles the presence of a phone number in the `selectedRecipients`
    private func toggleRecipient(_ phoneNumber: String) {
        if selectedRecipients.contains(phoneNumber) {
            selectedRecipients.removeAll { $0 == phoneNumber }
        } else {
            selectedRecipients.append(phoneNumber)
        }
    }
}




