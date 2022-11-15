//
//  EmailCheck.swift
//  mailChecker
//
//  Created by Юрий on 15.11.2022.
//

import Foundation

class EmailChecker {
    static let shared = EmailChecker()
    
    func checkEmail(email: String, completion: @escaping(MailResponseModel?)->Void) {
        let url = URL(string: "https://api.emailable.com/v1/verify?email=\(email)&api_key=live_bc20793d066057188063")
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MailResponseModel.self, from: data)
                    completion(result)
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
}
