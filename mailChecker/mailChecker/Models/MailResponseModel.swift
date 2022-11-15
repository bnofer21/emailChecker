//
//  MailResponseModel.swift
//  mailChecker
//
//  Created by Юрий on 15.11.2022.
//

import Foundation

struct MailResponseModel: Decodable {
    
    let mean: String?
    let email: String
    let reason: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case mean = "did_you_mean"
        case email
        case reason
        case state
    }
}

