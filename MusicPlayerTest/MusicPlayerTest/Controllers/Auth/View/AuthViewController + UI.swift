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
            textFieldControlsStackView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            textFieldControlsStackView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            textFieldControlsStackView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 24),
            textFieldControlsStackView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            buttonControlsStackView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            buttonControlsStackView.topAnchor.constraint(equalTo: textFieldControlsStackView.bottomAnchor, constant: 25),
            buttonControlsStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textFieldControlsStackView.topAnchor, constant: -50)
        ])
    }
    
    func setupUI() {
        view.addSubview(backgroundImage)
        view.addSubview(blurView)
        blurView.contentView.addSubview(textFieldControlsStackView)
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
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please, fill in all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
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
                    showAlert()
                }
            } else {
                if !email.isEmpty && !password.isEmpty {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if error == nil {
                            self.dismiss(animated: true)
                        }
                    }
                } else {
                    showAlert()
                }
            }
        }
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldName.resignFirstResponder()
        return true
    }
}


