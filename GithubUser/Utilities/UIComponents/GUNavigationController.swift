//
//  GUNavigationController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit

class GUNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }

    var statusBarStyle = UIStatusBarStyle.darkContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}
