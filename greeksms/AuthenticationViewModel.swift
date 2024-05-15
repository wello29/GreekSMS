//
//  AuthenticationViewModel.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/7/24.
//

import FirebaseAuth
import FirebaseFirestore


class AuthenticationViewModel: ObservableObject {
    @Published var isUserLoggedIn = false
    @Published var currentUser: User?
    private var db = Firestore.firestore()
    
    init() {
        isUserLoggedIn = Auth.auth().currentUser != nil
    }
    

    
    func fetchUserDetails() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user details: \(error)")
                return
            }
            guard let document = document, document.exists, let data = document.data() else {
                print("Document does not exist")
                return
            }
            
            DispatchQueue.main.async {
                let name = data["name"] as? String ?? "No Name"
                let accountSID = data["accountSID"] as? String ?? ""
                let authToken = data["authToken"] as? String ?? ""
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                
                self?.currentUser = User(name: name, uid: uid, accountSID: accountSID, authToken: authToken, phoneNumber: phoneNumber)
                self?.isUserLoggedIn = true // Assuming user is logged in if details are fetched
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let _ = authResult?.user { // Changed here to discard the value since it's unused
                DispatchQueue.main.async {
                    self.isUserLoggedIn = true
                    self.fetchUserDetails() // Fetch user details immediately after sign in
                }
            } else if let error = error {
                print("Sign in failed: \(error.localizedDescription)")
            }
        }
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isUserLoggedIn = false
            }
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }
}
