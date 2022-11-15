//
//  VerifyButton.swift
//  mailChecker
//
//  Created by Юрий on 15.11.2022.
//

import UIKit

class VerifyButton: UIButton {
    
    var indicator: UIActivityIndicatorView!
    var buttonText: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Verify", for: .normal)
        setTitleColor(.black, for: .normal)
        alpha = 0.3
        backgroundColor = .white
        layer.cornerRadius = 5
        clipsToBounds = true
        isEnabled = false
    }
    
    func showLoading() {
        buttonText = self.titleLabel?.text
        setTitle("", for: .normal)
        
        if indicator == nil {
            indicator = createIndicator()
        }
        showSpinning()
    }
    
    func hideLoading() {
        DispatchQueue.main.async(execute: {
            self.setTitle(self.buttonText, for: .normal)
            self.indicator.stopAnimating()
        })
    }
    
    private func createIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }
    
    private func showSpinning() {
        self.addView(indicator)
        indicator.center = self.center
        centerIndicatorInButton()
        indicator.startAnimating()
    }
    
    private func centerIndicatorInButton() {
        let xCenter = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenter)
        
        let yCenter = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
