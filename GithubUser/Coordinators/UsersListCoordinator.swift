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
        rootViewController = vc
    }

    override func stop() {
    }
    
}
