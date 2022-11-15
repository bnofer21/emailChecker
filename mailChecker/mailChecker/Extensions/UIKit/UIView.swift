//
//  UIView.swift
//  mailChecker
//
//  Created by Юрий on 14.11.2022.
//

import UIKit

extension UIView {
    func addView(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
