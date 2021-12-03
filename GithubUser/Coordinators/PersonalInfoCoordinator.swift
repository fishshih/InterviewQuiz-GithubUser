// 
//  PersonalInfoCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

class PersonalInfoCoordinator: Coordinator<Void> {

    override func start() {
        let vc = PersonalInfoViewController()
        rootViewController = vc
    }

    override func stop() {
    }
    
}
