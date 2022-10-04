//
//  Extension + UILabel.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 4.10.22.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, textAlignment: NSTextAlignment, font: UIFont) {
        self.init()
        self.font = font
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    convenience init(textAlignment: NSTextAlignment, font: UIFont, numberOfLines: Int) {
        self.init()
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
