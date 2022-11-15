//
//  Resources.swift
//  mailChecker
//
//  Created by Юрий on 07.11.2022.
//

import Foundation

enum Resources {
    
    enum Domains: String, CaseIterable {
        case yahoo = "@yahoo.com"
        case yandex = "@yandex.ru"
        case gmail = "@gmail.com"
    }
    
    enum LabelStates {
        case valid
        case invalid
        case none
    }
}


