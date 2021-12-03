// 
//  UsersListCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

enum UsersListCoordination {
    case switchTab
}

class UsersListCoordinator: Coordinator<UsersListCoordination> {

    override func start() {

        let vc = UsersListViewController()

        navigationController = .init(rootViewController: vc)

        let viewModel = UsersListViewModel(
            usersListAPI: UsersListAPI(),
            userInfoAPI: UserInfoAPI()
        )

        viewModel
            .reaction
            .sink {
                [weak output] reaction in
                switch reaction {
                case .switchTab:
                    output?.accept(.switchTab)
                case .showUserInfo(model: let model):
                    break
                }
            }
            .store(in: &cancelableSet)

        rootViewController = vc
    }

    // MARK: Private

    private var cancelableSet = Set<AnyCancellable>()
}
