// 
//  UsersListCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

enum UsersListCoordination {
    case switchTab
}

class UsersListCoordinator: Coordinator<UsersListCoordination> {

    override func start() {

        let vc = UsersListViewController()

        navigationController = GUNavigationController(rootViewController: vc)
        rootViewController = vc

        let viewModel = UsersListViewModel(
            usersListAPI: UsersListAPI(),
            userInfoAPI: UserInfoAPI()
        )

        vc.viewModel = viewModel

        viewModel
            .reaction
            .sink {
                [weak self] reaction in
                switch reaction {
                case .switchTab:
                    self?.output.accept(.switchTab)
                case .showUserInfo(model: let model):
                    self?.showUserInfo(by: model)
                }
            }
            .store(in: &cancelableSet)
    }
}

// MARK: Private

private extension UsersListCoordinator {

    func showUserInfo(by model: UserModel) {

        let next = UserInfoCoordinator(model: model)

        next
            .output
            .subscribe(onNext: {
                [weak self] reaction in
                switch reaction {
                case .dismiss:
                    self?.dismiss(coordinator: next)
                }
            })
            .disposed(by: disposeBag)

        presentCoordinator(coordinator: next)
    }
}
