// 
//  LoginCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/2.
//

import UIKit

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
        let viewModel = LoginViewModel(api: AuthAPI())

        rootViewController = vc
        vc.viewModel = viewModel

        viewModel
            .reaction
            .sink {
                [weak output] reaction in
                switch reaction {
                case .loginSuccess:
                    output?.accept(.loginSuccess)
                }
            }
            .store(in: &cancelableSet)

        window.rootViewController = rootViewController
    }

    // MARK: - Private

    private let window: UIWindow
}
