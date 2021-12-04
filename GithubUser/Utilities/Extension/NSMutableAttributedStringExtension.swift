//
//  NSMutableAttributedStringExtension.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/5.
//

import UIKit

extension NSMutableAttributedString {

    func append(text: String, font: UIFont? = nil, textColor: UIColor? = nil) {

        var attributes = [NSAttributedString.Key : Any]()

        if let font = font {
            attributes[.font] = font
        }

        if let color = textColor {
            attributes[.foregroundColor] = color
        }

        append(.init(string: text, attributes: attributes))
    }
}
