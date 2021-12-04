// 
//  PersonalInfoCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

enum PersonalInfoCoordination {
    case switchTab
}

class PersonalInfoCoordinator: Coordinator<PersonalInfoCoordination> {

    override func start() {

        let vc = PersonalInfoViewController()

        navigationController = GUNavigationController(rootViewController: vc)
        rootViewController = vc

        let viewModel = PersonalInfoViewModel(api: UserInfoAPI())

        vc.viewModel = viewModel

        viewModel
            .reaction
            .sink {
                [weak self] reaction in
                switch reaction {
                case .switchTab:
                    self?.output.accept(.switchTab)
                }
            }
            .store(in: &cancelableSet)
    }
}
