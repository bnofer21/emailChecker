//
//  ViewController.swift
//  mailChecker
//
//  Created by Юрий on 07.11.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    var domainButtons = [DomainButton]()
    var stackView = UIStackView()
    var verifyModel = VerificationModel()
    
    var invalidLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        return label
    }()
    
    var mailTextView: UITextView = {
        let textView = UITextView()
        textView.text = "E-Mail"
        textView.backgroundColor = .white
        textView.textColor = .gray
        textView.font = textView.font?.withSize(18)
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        return textView
    }()
    
    var checkButton = VerifyButton()
    
    var clearButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "clear")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setButtonTargets()
        configureStackView()
        mailTextView.delegate = self
    }
    
    // MARK: Configuring stackView with domain buttons
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        addButtonsStackView()
    }
    
    private func addButtonsStackView() {
        let numberOfButtons = Resources.Domains.allCases.count
        
        for i in 0..<numberOfButtons {
            let button = DomainButton()
            let domain = Resources.Domains.allCases[i].rawValue
            button.setTitle("\(domain)", for: .normal)
            button.addTarget(self, action: #selector(domainPressed(sender:)), for: .touchUpInside)
            button.domain = domain
            button.index = i
            
            domainButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    //MARK: Setting up UI + button targets
    private func setupView() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        view.addView(mailTextView)
        view.addView(invalidLabel)
        view.addView(checkButton)
        view.addView(clearButton)
        view.addView(stackView)
        changeLabel(.none)
    }
    
    private func setButtonTargets() {
        checkButton.addTarget(self, action: #selector(checkPressed(sender:)), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
    }
    
    //MARK: Change UI methods
    
    private func activeVerify(_ state: Bool) {
        checkButton.isEnabled = state
        checkButton.alpha = state ? 0.7 : 0.3
    }
    
    private func hideDomainButtons(_ state: Bool?,_ number: Int?) {
        if let state = state {
            for button in domainButtons {
                button.isHidden = state
            }
        }
        if let number = number {
            domainButtons[number].isHidden = true
        }
    }
    
    private func changeLabel(_ state: Resources.LabelStates) {
        
        switch state {
        case .valid:
            invalidLabel.textColor = .green
            invalidLabel.text = "E-Mail is valid!"
        case .invalid:
            invalidLabel.textColor = .red
            invalidLabel.text = "Invalid mail. Example: name@domain.com"
        default:
            invalidLabel.textColor = .white
            invalidLabel.text = "Please write your e-mail"
        }
    }
    
    private func deleteDomainCharacters() {
        if mailTextView.text.contains("@") {
            while mailTextView.text.last != "@" {
                mailTextView.text.removeLast()
            }
        }
    }
    
    //MARK: Address authentication
    
    private func authMail() -> Bool {
        if verifyModel.name != nil,
           verifyModel.domain != nil,
           verifyModel.dotCom != nil {
            if verifyModel.name!.count >= 4,
               verifyModel.domain!.count >= 2,
               verifyModel.dotCom!.count >= 2 {
                return true
            }
        }
        return false
    }
    
    //MARK: Buttons' methods
    
    @objc func checkPressed(sender: VerifyButton) {
        sender.showLoading()
        EmailChecker.shared.checkEmail(email: mailTextView.text) { result in
            if let result = result {
                DispatchQueue.main.async {
                    sleep(2)
                    if result.mean == nil {
                        self.presentAlert(title: "Address checked", mailModel: result)
                    } else {
                        self.presentReplaceAlert(title: "Adress checked", mailModel: result) { [weak self] in
                            self?.mailTextView.text = result.mean
                        }
                    }
                    sender.hideLoading()
                }
            }
        }
        
    }
    
    @objc func domainPressed(sender: DomainButton) {
        let domain = sender.domain
        deleteDomainCharacters()
        mailTextView.text.removeLast()
        mailTextView.text.append(domain)
        textViewDidChange(mailTextView)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func clearPressed() {
        mailTextView.text = nil
        textViewDidEndEditing(mailTextView)
        hideDomainButtons(true, nil)
        view.endEditing(true)
        changeLabel(.none)
        verifyModel = VerificationModel()
    }
    
}

// MARK: UITextView methods

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.text = nil
            textView.textColor = .black
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "E-Mail"
            textView.textColor = .gray
            activeVerify(false)
            clearButton.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        verifyModel.fullAddres = textView.text
        clearButton.isHidden = false
        
        if textView.text.contains("@") {
            hideDomainButtons(false, nil)
            if textView.text.last != "@" {
                for i in 0..<domainButtons.count {
                    let domain = domainButtons[i].domain
                    var textTrack = textView.text
                    while textTrack?.first != "@" {
                        textTrack?.removeFirst()
                    }
                    if !domain.contains(textTrack!) {
                        hideDomainButtons(nil, i)
                    }
                }
            }
        } else {
            hideDomainButtons(true, nil)
        }
        
        if authMail() {
            changeLabel(.valid)
            activeVerify(true)
        } else {
            changeLabel(.invalid)
            activeVerify(false)
        }
    }
}

// MARK: Setting constraints

extension ViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mailTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            mailTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mailTextView.widthAnchor.constraint(equalToConstant: 350),
            mailTextView.heightAnchor.constraint(equalToConstant: 40),
            
            invalidLabel.bottomAnchor.constraint(equalTo: mailTextView.topAnchor, constant: 0),
            invalidLabel.widthAnchor.constraint(equalTo: mailTextView.widthAnchor, constant: -7),
            invalidLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            checkButton.topAnchor.constraint(equalTo: mailTextView.bottomAnchor, constant: 15),
            checkButton.widthAnchor.constraint(equalTo: mailTextView.widthAnchor),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clearButton.topAnchor.constraint(equalTo: mailTextView.topAnchor, constant: 5),
            clearButton.bottomAnchor.constraint(equalTo: mailTextView.bottomAnchor, constant: -5),
            clearButton.trailingAnchor.constraint(equalTo: mailTextView.trailingAnchor, constant: -7),
            
            stackView.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 15),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: mailTextView.widthAnchor),
        ])
    }
}

