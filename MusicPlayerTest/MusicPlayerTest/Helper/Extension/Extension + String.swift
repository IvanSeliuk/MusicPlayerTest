//
//  Extension + String.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 2.10.22.
//

import UIKit

extension String {
    
    enum ValidTypes {
        case name, email, password
    }
    
    enum RegularEx: String {
        case name = "[a-zA-Z]{1,}"
        case email = "[a-zA-Z0-9._]+@[a-z]+\\.[a-z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name: regex = RegularEx.name.rawValue
        case .email: regex = RegularEx.email.rawValue
        case .password: regex = RegularEx.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
