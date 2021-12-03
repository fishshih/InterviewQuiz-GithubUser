// 
//  UserInfoCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

class UserInfoCoordinator: Coordinator<Void> {

    override func start() {
        let vc = UserInfoViewController()
        rootViewController = vc
    }

    override func stop() {
    }
    
}
