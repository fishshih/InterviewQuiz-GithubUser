// 
//  UserInfoCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

enum UserInfoCoordination {
    case dismiss
}

class UserInfoCoordinator: Coordinator<UserInfoCoordination> {

    init(model: UserModel) {
        self.model = model
    }

    override func start() {

        let vc = UserInfoViewController()

        rootViewController = vc

        let viewModel = UserInfoViewModel(model: model)

        vc.viewModel = viewModel

        viewModel
            .reaction
            .sink {
                [weak output] reaction in
                switch reaction {
                case .dismiss:
                    output?.accept(.dismiss)
                }
            }
            .store(in: &cancelableSet)
    }

    // MARK: Private

    private let model: UserModel
}
