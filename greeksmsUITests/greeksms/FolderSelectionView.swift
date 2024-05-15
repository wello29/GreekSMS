//
//  FolderSelectionView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/4/24.
//

import Foundation
import SwiftUI

struct FolderSelectionView: View {
    @ObservedObject var viewModel: ContactsViewModel
    var contact: SMSContact
    
    var body: some View {
        List {
            ForEach(viewModel.groups, id: \.id) { group in
                Button(action: {
                    viewModel.addContactToGroup(contact: contact, group: group)
                }) {
                    Text(group.name)
                }
            }
        }
        .navigationTitle("Select a Folder")
        .navigationBarTitleDisplayMode(.inline)
    }
}
