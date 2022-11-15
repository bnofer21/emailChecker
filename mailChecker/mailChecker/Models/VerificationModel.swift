//
//  VerificationModel.swift
//  mailChecker
//
//  Created by Юрий on 14.11.2022.
//

import Foundation

struct VerificationModel {
    
    var name: String?
    var domain: String?
    var dotCom: String?
    var fullAddres: String? {
        didSet {
            guard let address = fullAddres else { return }
            getName(address: address)
        }
    }
    
    mutating func getName(address: String) {
        if address.contains("@"), address.contains(".") {
            if let check = address.components(separatedBy: "@").first {
                name = check
            }
            if let check = (address.components(separatedBy: "@").last?.components(separatedBy: ".").first) {
                domain = check
            }
            if let check = (address.components(separatedBy: ".").last) {
                dotCom = check
            }
        }
    }
}
