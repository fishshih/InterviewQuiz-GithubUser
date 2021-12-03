// 
//  UserInfoViewModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Prototype

protocol UserInfoViewModelInput {

}

protocol UserInfoViewModelOutput {

}

protocol UserInfoViewModelPrototype {
    var input: UserInfoViewModelInput { get }
    var output: UserInfoViewModelOutput { get }
}

// MARK: - View model

class UserInfoViewModel: UserInfoViewModelPrototype {

    var input: UserInfoViewModelInput { self }
    var output: UserInfoViewModelOutput { self }

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension UserInfoViewModel: UserInfoViewModelInput {

}

extension UserInfoViewModel: UserInfoViewModelOutput {

}

// MARK: - Private function

private extension UserInfoViewModel {

}
