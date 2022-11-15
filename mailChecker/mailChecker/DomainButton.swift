//
//  DomainButton.swift
//  mailChecker
//
//  Created by Юрий on 07.11.2022.
//

import UIKit

class DomainButton: UIButton {
    
    var domain = String()
    var index = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0.7
        layer.cornerRadius = 5
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
