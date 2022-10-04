//
//  AuthViewController + UI.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 2.10.22.
//

import UIKit
import Firebase

extension AuthViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: backgroundImage.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textFieldStackView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            textFieldStackView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 24),
            textFieldStackView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -24)
                ])
        
        NSLayoutConstraint.activate([
            buttonControlsStackView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            buttonControlsStackView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 25),
            buttonControlsStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -50)
        ])
    }
    
    func setupUI() {
        view.addSubview(backgroundImage)
        view.addSubview(blurView)
        blurView.contentView.addSubview(textFieldStackView)
        blurView.contentView.addSubview(buttonControlsStackView)
        blurView.contentView.addSubview(titleLabel)
        navigationController?.navigationBar.isHidden = true
        setDelegate()
    }
    
    private func setDelegate() {
        textFieldPassword.delegate = self
        textFieldEmail.delegate = self
        textFieldName.delegate = self
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Please, fill in all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func setTextField(textField: UITextField, label: UILabel, validType: String.ValidTypes, validMessage: String, wrongMessage: String, string: String, range: NSRange) {
        
        let text = (textField.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        textField.text = result
        
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .green
        } else {
            label.text = wrongMessage
            label.textColor = .red
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = textFieldEmail.text
        let name = textFieldName.text
        let password = textFieldPassword.text
        if let email = email, let name = name, let password = password  {
            if signUp {
                if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if error == nil {
                            if let result = result {
                                print(result.user.uid)
                                let ref = Database.database().reference().child("users")
                                ref.child(result.user.uid).updateChildValues(["name" : name, "email" : email])
                                self.dismiss(animated: true)
                            }
                        }
                    }
                } else {
                    showErrorAlert()
                }
            } else {
                if !email.isEmpty && !password.isEmpty {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if error == nil {
                            self.dismiss(animated: true)
                        }
                    }
                } else {
                    showErrorAlert()
                }
            }
        }
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldName.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case textFieldName: setTextField(textField: textFieldName,
                                         label: nameLabel,
                                         validType: .name,
                                         validMessage: "Name is valid",
                                         wrongMessage: "Only A-Z,a-z and at least 1 character",
                                         string: string,
                                         range: range)
        case textFieldEmail: setTextField(textField: textFieldEmail,
                                         label: emailLabel,
                                         validType: .email,
                                         validMessage: "Email is valid",
                                         wrongMessage: "xxx@xxx.xx",
                                         string: string,
                                         range: range)
        case textFieldPassword: setTextField(textField: textFieldPassword,
                                         label: passwordLabel,
                                         validType: .password,
                                         validMessage: "Password is valid",
                                         wrongMessage: "Passwords should contain min one capital and lowercase letter, one number and at least 6 characters",
                                         string: string,
                                         range: range)
        default: break
        }
        return false
    }
}


