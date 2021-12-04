//
//  UIImageExtension.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit

extension UIImage {

    static func withColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
