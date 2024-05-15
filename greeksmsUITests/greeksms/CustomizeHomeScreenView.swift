//
//  CustomizeHomeScreenView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/8/24.
//

import Foundation
// CustomizeHomeScreenView.swift
// greeksms
// Created by Tyler Zastrow on 5/8/24.

import SwiftUI

struct CustomizeHomeScreenView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var contactsViewModel: ContactsViewModel

    @State private var selectedGroupID: String = ""
    @State private var title = ""
    @State private var subtitle = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quick Message Button Details")) {
                    Picker("Group", selection: $selectedGroupID) {
                        ForEach(contactsViewModel.groups, id: \.id) { group in
                            Text(group.name).tag(group.id)
                        }
                    }

                    TextField("Button Title", text: $title)
                    TextField("Subtitle", text: $subtitle)
                }

                Button("Add Quick Message Button") {
                    let newButton = QuickMessageButton(
                        id: UUID().uuidString,
                        groupID: selectedGroupID,
                        title: title,
                        subtitle: subtitle
                    )
                    viewModel.addQuickMessageButton(button: newButton)
                    clearFields()
                }
                .disabled(title.isEmpty || subtitle.isEmpty || selectedGroupID.isEmpty)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
            }
            .navigationTitle("Customize Home Screen")
            .navigationBarItems(trailing: Button("Done") {
                viewModel.showingCustomizeScreen = false
            })
        }
    }

    private func clearFields() {
        selectedGroupID = ""
        title = ""
        subtitle = ""
    }
}
