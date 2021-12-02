//
//  AppCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/2.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: Coordinator<Void> {

    // MARK: - Life cycle

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        switchToState(.login)
    }

    // MARK: - Private

    enum AppState {
        case initial
        case login
        case main
    }

    private var state = AppState.initial

    private let window: UIWindow
}

// MARK: - Private function

private extension AppCoordinator {

    func switchToState(_ newState: AppState) {

        guard state != newState else { return }

        switch newState {
        case .initial:
            break
        case .login:
            toLogin()
        case .main:
            toAppMain()
        }

        state = newState
    }

    func toLogin() {
        
        let next = LoginCoordinator(window: window)

        next
            .output
            .subscribe(onNext: {
                [weak self] reaction in
                switch reaction {
                case .loginSuccess:
                    break
                }
            })
            .disposed(by: disposeBag)

        next.start()
        store(coordinator: next)
    }

    func toAppMain() {
//        let next = AppMainCoordinator(window: window)
//        next.start()
//        childCoordinator = next
    }
}
