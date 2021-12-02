// 
//  LoginCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/2.
//

import UIKit
import RxSwift
import RxCocoa

enum LoginCoordinationReaction {
    case loginSuccess
}

class LoginCoordinator: Coordinator<LoginCoordinationReaction> {

    // MARK: - Life cycle

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {

        let vc = LoginViewController()
        let viewModel = LoginViewModel()

        rootViewController = vc
        vc.viewModel = viewModel

        window.rootViewController = rootViewController
    }

    // MARK: - Private

    private let window: UIWindow
}
