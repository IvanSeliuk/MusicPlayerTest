//
//  AuthViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 30.09.22.
//

import UIKit
import Firebase
import DTTextField
import PasswordTextField

class AuthViewController: UIViewController {
    var signUp: Bool = true {
        willSet {
            if newValue {
                titleLabel.text = "Registration"
                textFieldNameStackView.isHidden = false
                signIn.setTitle("Sign In", for: .normal)
            } else {
                titleLabel.text = "Sign In"
                textFieldNameStackView.isHidden = true
                signIn.setTitle("Sign Up", for: .normal)
            }
        }
    }
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "4d")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let blurEffect = UIBlurEffect(style: .dark)
    lazy var blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.clipsToBounds = true
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.effect = blurEffect
        return blur
    }()
    
    lazy var textFieldName: UITextField = {
        let name = UITextField()
        name.placeholder = "Enter your name"
        name.returnKeyType = .done
        name.borderStyle = .roundedRect
        name.textContentType = .name
        return name
    }()
    
    lazy var textFieldEmail: UITextField = {
        let email = UITextField()
        email.placeholder = "Enter your mail"
        email.returnKeyType = .done
        email.borderStyle = .roundedRect
        email.textContentType = .emailAddress
        return email
    }()
    
    lazy var textFieldPassword: PasswordTextField = {
        let password = PasswordTextField()
        password.placeholder = "Enter your password"
        password.borderStyle = .roundedRect
        password.returnKeyType = .done
        
        return password
    }()
    
    lazy var signIn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(tapButtonSignIn), for: .touchUpInside)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    @objc private func tapButtonSignIn() {
        signUp = !signUp
    }
    
    lazy var accountLabel: UILabel = {
        let label = UILabel(text: "Do you have an account yet?",
                            textColor: .white,
                            textAlignment: .center,
                            font: .systemFont(ofSize: 16, weight: .light))
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: "It's not valid name?",
                            textColor: .white,
                            textAlignment: .left,
                            font: .systemFont(ofSize: 12, weight: .light))
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel(text: "It's not valid email?",
                            textColor: .red,
                            textAlignment: .left,
                            font: .systemFont(ofSize: 12, weight: .light))
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel(text: "It's not valid password?",
                            textColor: .red,
                            textAlignment: .left,
                            font: .systemFont(ofSize: 12, weight: .light))
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "Registration",
                            textColor: .white,
                            textAlignment: .center,
                            font: UIFont(name: "Marker Felt", size: 30) ?? .systemFont(ofSize: 30))
        return label
    }()
    
    lazy var textFieldNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldName, nameLabel],
                                    axis: .vertical,
                                    spacing: 2,
                                    distribution: .equalSpacing)
        return stackView
    }()
    
    lazy var textFieldEmailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldEmail, emailLabel],
                                    axis: .vertical,
                                    spacing: 2,
                                    distribution: .equalSpacing)
        return stackView
    }()
    
    lazy var textFieldPasswordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldPassword, passwordLabel],
                                    axis: .vertical,
                                    spacing: 2,
                                    distribution: .equalSpacing)
        return stackView
    }()
    
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldNameStackView, textFieldEmailStackView, textFieldPasswordStackView],
                                    axis: .vertical,
                                    spacing: 5,
                                    distribution: .equalSpacing)
        return stackView
    }()
    
    lazy var buttonControlsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [accountLabel, signIn],
                                    axis: .vertical,
                                    spacing: 8,
                                    distribution: .fillEqually)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        //emailLabel.alpha = 0
       // passwordLabel.alpha = 0
    }
}
    
