//
//  Alerts.swift
//  mailChecker
//
//  Created by Юрий on 15.11.2022.
//

import UIKit

extension ViewController {
    
    func presentAlert(title: String, mailModel: MailResponseModel) {
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
            let alertController = UIAlertController(title: title, message: "State: \(mailModel.state)", preferredStyle: .alert)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        
    }
    
    func presentReplaceAlert(title: String, mailModel: MailResponseModel,completion: @escaping () -> Void) {
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        let replaceAction = UIAlertAction(title: "Replace", style: .default) { _ in
            completion()
        }
        
        let alertController = UIAlertController(title: title, message: "State: \(mailModel.state)\nReason: \(mailModel.reason)\nDid you mean:\n\(mailModel.email)", preferredStyle: .alert)
        alertController.addAction(okAction)
        alertController.addAction(replaceAction)
        present(alertController, animated: true)
    }
}
