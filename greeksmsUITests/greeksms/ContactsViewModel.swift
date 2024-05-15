//
//  ContactsViewModel.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/4/24.
//
import SwiftUI
import FirebaseFirestore
import Combine


struct SMSContact: Identifiable, Hashable {
    let id: String
    var name: String
    var phoneNumber: String
}

struct SMSGroup: Identifiable, Hashable {
    let id: String
    var name: String
    var contacts: [SMSContact]
}
struct Removal: Identifiable {
    let id = UUID()
    let contact: SMSContact
    let group: SMSGroup
}

class ContactsViewModel: ObservableObject {
    @Published var contacts = [SMSContact]()
    @Published var groups = [SMSGroup]()
    @Published var groupToDelete: SMSGroup?
    @Published var contactToRemove: Removal?
    @Published var contactToDelete: SMSContact?
    @Published var selectedTab: Int = 0
    
    private var db = Firestore.firestore()
    var user: User
    
    init(user: User) {
        self.user = user
        fetchContacts()
        fetchGroups()
    }
    
    
    
    func fetchContacts() {
        db.collection("users").document(user.uid).collection("contacts")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching contacts: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.contacts = documents.map { document in
                    SMSContact(
                        id: document.documentID,
                        name: document.data()["name"] as? String ?? "",
                        phoneNumber: document.data()["phoneNumber"] as? String ?? ""
                    )
                }
            }
    }
    
    
    
    
    
    func addContact(contact: SMSContact) {
        let contactRef = db.collection("users").document(user.uid).collection("contacts").document(contact.id)
        contactRef.setData([
            "name": contact.name,
            "phoneNumber": contact.phoneNumber
        ]) { error in
            if let error = error {
                print("Error adding contact: \(error.localizedDescription)")
            } else {
                print("Contact added to Firestore, waiting for snapshot listener to update UI.")
            }
        }
    }
    
    
    func resolveContactIDs(_ contactIDs: [String]) -> [SMSContact] {
        return contacts.filter { contactIDs.contains($0.id) }
    }
    
    func fetchGroupContacts(groupID: String, completion: @escaping ([SMSContact]) -> Void) {
        db.collection("users").document(user.uid).collection("groups").document(groupID).getDocument { document, error in
            if let document = document, document.exists {
                let contactIDs = document.data()?["contacts"] as? [String] ?? []
                let contactsInGroup = self.resolveContactIDs(contactIDs)
                completion(contactsInGroup)
            } else {
                print("Error fetching group contacts: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }
    }
    
    func deleteContact(contactID: String) {
        db.collection("users").document(user.uid).collection("contacts").document(contactID).delete() { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error deleting contact: \(error.localizedDescription)")
            } else {
                print("Contact successfully deleted.")
                self.contacts.removeAll { $0.id == contactID }
            }
        }
    }
    
    
    
    func fetchGroups() {
        db.collection("users").document(user.uid).collection("groups")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching groups: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.groups = documents.map { document in
                    let contactIDs = document.data()["contacts"] as? [String] ?? []
                    let contactsInGroup = contactIDs.compactMap { id in
                        self.contacts.first { $0.id == id }
                    }
                    return SMSGroup(
                        id: document.documentID,
                        name: document.data()["name"] as? String ?? "",
                        contacts: contactsInGroup
                    )
                }
            }
    }
    
    
    func addGroup(groupName: String) {
        let newGroup = SMSGroup(id: UUID().uuidString, name: groupName, contacts: [])
        db.collection("users").document(user.uid).collection("groups").document(newGroup.id)
            .setData([
                "name": groupName,
                "contacts": []
            ]) { error in
                if let error = error {
                    print("Error creating group: \(error.localizedDescription)")
                } else {
                    print("Group created in Firestore, waiting for snapshot listener to update UI.")
                }
            }
    }
    
    func deleteGroup(groupID: String) {
        let groupRef = db.collection("users").document(user.uid).collection("groups").document(groupID)
        groupRef.delete { error in
            if let error = error {
                print("Error deleting group: \(error.localizedDescription)")
            } else {
                print("Group successfully deleted")
                self.groups.removeAll { $0.id == groupID }
            }
        }
    }
    
    func updateContact(_ contact: SMSContact) {
        let docRef = db.collection("users").document(user.uid).collection("contacts").document(contact.id)
        let updateData = ["name": contact.name, "phoneNumber": contact.phoneNumber]
        docRef.updateData(updateData) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error updating contact: \(error.localizedDescription)")
            } else {
                print("Contact successfully updated in Firestore.")
                if let index = self.contacts.firstIndex(where: { $0.id == contact.id }) {
                    self.contacts[index] = contact
                    print("Local contact data updated.")
                }
            }
        }
    }
    
    
    
    func addContactToGroup(contact: SMSContact, group: SMSGroup) {
        let groupRef = db.collection("users").document(user.uid).collection("groups").document(group.id)
        groupRef.updateData([
            "contacts": FieldValue.arrayUnion([contact.id])
        ]) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error adding contact to group: \(error.localizedDescription)")
            } else {
                print("Contact added to group in Firestore, waiting for snapshot listener to update UI.")
            }
        }
    }
    
    
    func removeContactFromGroup(contact: SMSContact, group: SMSGroup) {
        let groupRef = db.collection("users").document(user.uid).collection("groups").document(group.id)
        groupRef.updateData([
            "contacts": FieldValue.arrayRemove([contact.id])
        ]) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error removing contact from group: \(error.localizedDescription)")
            } else {
                print("Contact removed from group successfully.")
                if let index = self.groups.firstIndex(where: { $0.id == group.id }) {
                    self.groups[index].contacts.removeAll { $0.id == contact.id }
                }
            }
        }
    }
    
    func confirmRemoveContactFromGroup(contact: SMSContact, group: SMSGroup) {
        contactToRemove = Removal(contact: contact, group: group)
    }

    func confirmDeleteContact(contact: SMSContact) {
        contactToDelete = contact
    }

    func deleteConfirmedContact() {
        if let contact = contactToDelete {
            deleteContact(contactID: contact.id)
            contactToDelete = nil
        }
    }
    
    func bulkAddContactsToGroup(contactIDs: [String], groupID: String) {
        // Retrieve the group object using the groupID
        if let group = self.groups.first(where: { $0.id == groupID }) {
            // Retrieve contact objects from the provided IDs
            let contactsToAdd = self.contacts.filter { contactIDs.contains($0.id) }
            
            // Call addContactToGroup for each contact
            for contact in contactsToAdd {
                self.addContactToGroup(contact: contact, group: group)
            }
        } else {
            print("Group not found with the given ID")
        }
    }
}
