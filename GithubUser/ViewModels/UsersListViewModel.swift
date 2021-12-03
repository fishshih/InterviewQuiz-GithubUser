// 
//  UsersListViewModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

// MARK: - Reaction

enum UsersListViewModelReaction {
    case switchTab
    case showUserInfo(model: UserModel)
}

// MARK: - Prototype

protocol UsersListViewModelInput {
    func switchTab()
    func showUserInfo(by modelIndex: Int)
}

protocol UsersListViewModelOutput {
    var models: AnyPublisher<[UsersListElementModel], Never> { get }
}

protocol UsersListViewModelPrototype {
    var input: UsersListViewModelInput { get }
    var output: UsersListViewModelOutput { get }
}

// MARK: - View model

class UsersListViewModel: UsersListViewModelPrototype {

    let reaction = PassthroughSubject<UsersListViewModelReaction, Never>()

    var input: UsersListViewModelInput { self }
    var output: UsersListViewModelOutput { self }

    init(usersListAPI: UsersListAPIPrototype?,
         userInfoAPI: UserInfoAPIPrototype?) {

        self.usersListAPI = usersListAPI
        self.userInfoAPI = userInfoAPI

        guard
            let usersListAPI = self.usersListAPI,
            let userInfoAPI = self.userInfoAPI
        else {
            return
        }

        bind(usersListAPI: usersListAPI, userInfoAPI: userInfoAPI)
    }

    private let usersListAPI: UsersListAPIPrototype?
    private let userInfoAPI: UserInfoAPIPrototype?

    @Published private var userModels = [UsersListElementModel]()

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension UsersListViewModel: UsersListViewModelInput {

    func switchTab() {
        reaction.send(.switchTab)
    }

    func showUserInfo(by modelIndex: Int) {
        guard let model = userModels[safe: modelIndex] else { return }
        userInfoAPI?.fetch(name: model.login)
    }
}

extension UsersListViewModel: UsersListViewModelOutput {

    var models: AnyPublisher<[UsersListElementModel], Never> {
        $userModels.eraseToAnyPublisher()
    }
}

// MARK: - Private function

private extension UsersListViewModel {

    func bind(usersListAPI: UsersListAPIPrototype,
              userInfoAPI: UserInfoAPIPrototype) {

        usersListAPI
            .result
            .subscribe(onNext: {
                [weak self] result in
                switch result {
                case .success(let models):
                    self?.userModels = models
                case .failure(let error):
                    assert(false, "\(error)")
                }
            })
            .disposed(by: disposeBag)

        userInfoAPI
            .result
            .subscribe(onNext: {
                [weak self] result in
                switch result {
                case .success(let model):
                    self?.reaction.send(.showUserInfo(model: model))
                case .failure(let error):
                    assert(false, "\(error)")
                }
            })
            .disposed(by: disposeBag)

        usersListAPI.fetch()
    }
}
