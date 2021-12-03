// 
//  UsersListViewModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Prototype

protocol UsersListViewModelInput {

}

protocol UsersListViewModelOutput {

}

protocol UsersListViewModelPrototype {
    var input: UsersListViewModelInput { get }
    var output: UsersListViewModelOutput { get }
}

// MARK: - View model

class UsersListViewModel: UsersListViewModelPrototype {

    var input: UsersListViewModelInput { self }
    var output: UsersListViewModelOutput { self }

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension UsersListViewModel: UsersListViewModelInput {

}

extension UsersListViewModel: UsersListViewModelOutput {

}

// MARK: - Private function

private extension UsersListViewModel {

}
