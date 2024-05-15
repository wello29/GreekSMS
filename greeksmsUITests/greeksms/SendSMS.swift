//
//  SendSMS.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/3/24.
//


import Foundation
import Alamofire

struct SMSManager {
    static func sendSMS(user: User, toRecipients: String, messageBody: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(user.accountSID)/Messages.json"
        let parameters: [String: String] = [
            "From": user.phoneNumber,
            "To": toRecipients,
            "Body": messageBody
        ]
        let credentialData = "\(user.accountSID):\(user.authToken)".data(using: .utf8)!.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(credentialData)"
        ]

        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Message sent successfully")
                    completion(true, nil)
                case .failure(let error):
                    print("Failed to send message: \(error.localizedDescription)")
                    completion(false, error)
                }
            }
    }

    static func sendBulkSMS(user: User, toRecipients: [String], messageBody: String, completion: @escaping (Bool, Error?) -> Void) {
        var errors = [Error]()
        let dispatchGroup = DispatchGroup()

        for recipient in toRecipients {
            dispatchGroup.enter()
            sendSMS(user: user, toRecipients: recipient, messageBody: messageBody) { success, error in
                if let error = error {
                    errors.append(error)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if errors.isEmpty {
                completion(true, nil)
            } else {
                completion(false, errors.first)
            }
        }
    }
}



