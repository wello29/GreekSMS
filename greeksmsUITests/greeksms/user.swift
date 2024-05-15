//
//  user.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/7/24.
//

import Foundation
import Combine

class User: ObservableObject {
    @Published var name: String
    @Published var uid: String
    @Published var accountSID: String
    @Published var authToken: String
    @Published var phoneNumber: String

    init(name: String, uid: String, accountSID: String, authToken: String, phoneNumber: String) {
        self.name = name
        self.uid = uid
        self.accountSID = accountSID
        self.authToken = authToken
        self.phoneNumber = phoneNumber
    }
}

