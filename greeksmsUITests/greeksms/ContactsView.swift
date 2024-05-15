//
//  ContactsView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/9/24.
//


import SwiftUI
import FirebaseFirestore

struct ContactsView: View {
    @ObservedObject var viewModel: ContactsViewModel
    @State private var selectedTab: Int = 0  // 0 for "All Contacts", 1 for "Folders"
    @State private var selectedContact: SMSContact?  // Optional state to track selected contact
    @State private var isEditing = false
    @State private var selectedContacts = Set<String>()  // To store selected contact IDs
    @State private var showingFolderPicker = false
    @State private var showingOptions = false
    
    //Handle multiple alerts in the folderTab()
    enum ActiveAlert: Identifiable {
        case deleteGroup(SMSGroup), removeContact(Removal)

        // Computed property to conform to Identifiable
        var id: String {
            switch self {
            case .deleteGroup(let group):
                return group.id
            case .removeContact(let removal):
                return removal.contact.id + removal.group.id
            }
        }
    }
    @State private var activeAlert: ActiveAlert?
    //Done Handling Alerts in the folderTab()
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    allContactsTab
                        .sheet(item: $selectedContact) { contact in
                            ContactCardView(viewModel: viewModel, contact: .constant(contact))
                        }
                } else {
                    foldersTab
                        .sheet(item: $selectedContact) { contact in
                            ContactCardView(viewModel: viewModel, contact: .constant(contact))
                        }
                }
                
                // Sliding Toggle at the Bottom
                VStack {
                    Picker("", selection: $selectedTab) {
                        Text("All Contacts").tag(0)
                        Text("Folders").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab == 0 {
                        Menu {
                            Button("Select Contacts") {
                                isEditing = true
                            }
                            Button("Add Contact", action: presentAddContactDialog)
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    } else {
                        addButton(action: presentAddFolderDialog)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if selectedTab == 0 && isEditing {
                        Button("Add to Folder") {
                            showingFolderPicker = true
                        }
                        .disabled(selectedContacts.isEmpty)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab == 0 && isEditing {
                        Button("Done") {
                            isEditing = false
                            selectedContacts.removeAll()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingFolderPicker) {
                FolderPickerView(
                    isPresented: $showingFolderPicker,
                    contactIDs: Array(selectedContacts),
                    viewModel: viewModel,
                    onComplete: {
                        selectedContacts.removeAll()
                        isEditing = false
                    }
                )
            }
        }
        .onAppear {
            viewModel.fetchContacts()
            viewModel.fetchGroups()
        }
    }
    
    private var allContactsTab: some View {
        List {
            ForEach(viewModel.contacts, id: \.id) { contact in
                HStack {
                    if isEditing {
                        SelectionIndicator(isSelected: selectedContacts.contains(contact.id)) {
                            if selectedContacts.contains(contact.id) {
                                selectedContacts.remove(contact.id)
                            } else {
                                selectedContacts.insert(contact.id)
                            }
                        }
                    }
                    Text(contact.name)
                    Spacer()
                    Text(contact.phoneNumber)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        confirmDeleteContact(contact: contact)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Button {
                        self.selectedContact = contact
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .alert(item: $viewModel.contactToDelete) { contact in
            Alert(
                title: Text("Delete Contact"),
                message: Text("Are you sure you want to delete '\(contact.name)'?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteConfirmedContact()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func confirmDeleteContact(contact: SMSContact) {
        viewModel.confirmDeleteContact(contact: contact)
    }

    private var foldersTab: some View {
        List {
            ForEach(viewModel.groups, id: \.id) { group in
                Section(header: HStack {
                    Text(group.name)
                    Spacer()
                    Button(action: {
                        activeAlert = .deleteGroup(group)  // Set the alert type
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }) {
                    ForEach(group.contacts, id: \.id) { contact in
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Text(contact.phoneNumber)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                activeAlert = .removeContact(Removal(contact: contact, group: group))  // Set the alert type
                            } label: {
                                Label("Remove", systemImage: "minus.circle.fill")
                            }
                        }
                    }
                }
            }
        }
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .deleteGroup(let group):
                return Alert(
                    title: Text("Delete Folder"),
                    message: Text("Are you sure you want to delete the folder '\(group.name)'?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteGroup(groupID: group.id)
                    },
                    secondaryButton: .cancel()
                )
            case .removeContact(let removal):
                return Alert(
                    title: Text("Remove Contact"),
                    message: Text("Are you sure you want to remove '\(removal.contact.name)' from the folder '\(removal.group.name)'?"),
                    primaryButton: .destructive(Text("Remove")) {
                        viewModel.removeContactFromGroup(contact: removal.contact, group: removal.group)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    
    //Confirming functions for "Are you sure"
    private func confirmDeleteGroup(group: SMSGroup) {
        viewModel.groupToDelete = group  // Ensure you're assigning the group object itself
    }


    private func confirmRemoveContactFromGroup(contact: SMSContact, group: SMSGroup) {
        viewModel.contactToRemove = Removal(contact: contact, group: group)
    }
    
    private func addButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "plus")
        }
    }
    
    /// Helper method to present a dialog to add a new contact
    private func presentAddContactDialog() {
        let alert = UIAlertController(title: "New Contact", message: "Enter the contact details",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Phone Number"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let name = alert.textFields?.first?.text ?? ""
            let phoneNumber = alert.textFields?.last?.text ?? ""
            let newContact = SMSContact(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
            viewModel.addContact(contact: newContact)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    private func presentAddFolderDialog() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(title: "New Folder", message: "Enter the folder name",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Folder Name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let folderName = alert.textFields?.first?.text, !folderName.isEmpty {
                self.viewModel.addGroup(groupName: folderName)
            } else {
                print("Folder name is required")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        rootViewController.present(alert, animated: true, completion: nil)
    }
}

private struct SelectionIndicator: View {
    let isSelected: Bool
    let toggle: () -> Void
    
    var body: some View {
        Button(action: toggle) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .blue : .gray)
                .padding(.trailing, 8)
        }
    }
}

struct FolderPickerView: View {
    @Binding var isPresented: Bool
    var contactIDs: [String]
    @ObservedObject var viewModel: ContactsViewModel
    var onComplete: () -> Void
    
    var body: some View {
        NavigationView {
            List(viewModel.groups, id: \.id) { group in
                Button(action: {
                    viewModel.bulkAddContactsToGroup(contactIDs: contactIDs, groupID: group.id)
                    onComplete()
                    isPresented = false
                }) {
                    HStack {
                        Text(group.name)
                        Spacer()
                        Image(systemName: "folder")
                    }
                }
            }
            .navigationTitle("Select Folder")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

