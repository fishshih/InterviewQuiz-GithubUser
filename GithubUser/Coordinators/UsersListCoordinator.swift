// 
//  UsersListCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

class UsersListCoordinator: Coordinator<Void> {

    override func start() {
        let vc = UsersListViewController()
        rootViewController = vc
    }

    override func stop() {
    }
    
}
