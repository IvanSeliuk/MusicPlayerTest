//
//  AuthViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 30.09.22.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    var signUp: Bool = true {
        willSet {
            if newValue {
                titleLabel.text = "Registration"
                textFieldName.isHidden = false
                signIn.setTitle("Sign In", for: .normal)
            } else {
                titleLabel.text = "Sign In"
                textFieldName.isHidden = true
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
        name.borderStyle = .roundedRect
        name.textColor = .black
        name.returnKeyType = .done
        name.textContentType = .name
        return name
    }()
    
    lazy var textFieldEmail: UITextField = {
        let email = UITextField()
        email.placeholder = "Enter your mail"
        email.borderStyle = .roundedRect
        email.textColor = .black
        email.returnKeyType = .done
        email.textContentType = .emailAddress
        return email
    }()
    
    lazy var textFieldPassword: UITextField = {
        let password = UITextField()
        password.placeholder = "Enter your password"
        password.borderStyle = .roundedRect
        password.textColor = .black
        password.returnKeyType = .done
        password.textContentType = .password
        password.isSecureTextEntry = true
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
        let label = UILabel()
        label.text = "Do you have an account yet?"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 30)
        return label
    }()
    
    lazy var textFieldControlsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldName, textFieldEmail, textFieldPassword],
                                    axis: .vertical,
                                    spacing: 10,
                                    distribution: .fillEqually)
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
    }
}
    
