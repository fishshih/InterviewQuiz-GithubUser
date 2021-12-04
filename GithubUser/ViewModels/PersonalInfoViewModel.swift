// 
//  PersonalInfoViewModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

// MARK: - Reaction

enum PersonalInfoViewModelReaction {
    case switchTab
}

// MARK: - Prototype

protocol PersonalInfoViewModelInput {
    func switchTab()
}

protocol PersonalInfoViewModelOutput {
    var avatarURLString: AnyPublisher<String, Never> { get }
    var name: AnyPublisher<String, Never> { get }
    var loginID: AnyPublisher<String, Never> { get }
    var numberOfFollowers: AnyPublisher<Int, Never> { get }
    var numberOfFollowing: AnyPublisher<Int, Never> { get }
    var email: AnyPublisher<String?, Never> { get }
    var numberOfRepositories: AnyPublisher<Int, Never> { get }
}

protocol PersonalInfoViewModelPrototype {
    var input: PersonalInfoViewModelInput { get }
    var output: PersonalInfoViewModelOutput { get }
}

// MARK: - View model

class PersonalInfoViewModel: PersonalInfoViewModelPrototype {

    let reaction = PassthroughSubject<PersonalInfoViewModelReaction, Never>()

    var input: PersonalInfoViewModelInput { self }
    var output: PersonalInfoViewModelOutput { self }

    init(api: UserInfoAPIPrototype?) {

        self.api = api

        guard let api = self.api else { return }

        bind(api: api)
    }

    private let api: UserInfoAPIPrototype?

    @Published private var model: UserModel?

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension PersonalInfoViewModel: PersonalInfoViewModelInput {

    func switchTab() {
        reaction.send(.switchTab)
    }
}

extension PersonalInfoViewModel: PersonalInfoViewModelOutput {

    private var modelPublisher: AnyPublisher<UserModel, Never> {
        $model
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    var avatarURLString: AnyPublisher<String, Never> {
        modelPublisher.map(\.avatarURL).eraseToAnyPublisher()
    }

    var name: AnyPublisher<String, Never> {
        modelPublisher.map(\.name).eraseToAnyPublisher()
    }

    var loginID: AnyPublisher<String, Never> {
        modelPublisher.map(\.login).eraseToAnyPublisher()
    }

    var numberOfFollowers: AnyPublisher<Int, Never> {
        modelPublisher.map(\.followers).eraseToAnyPublisher()
    }

    var numberOfFollowing: AnyPublisher<Int, Never> {
        modelPublisher.map(\.following).eraseToAnyPublisher()
    }

    var numberOfRepositories: AnyPublisher<Int, Never> {
        modelPublisher.map(\.publicRepos).eraseToAnyPublisher()
    }

    var email: AnyPublisher<String?, Never> {
        modelPublisher.map(\.email).eraseToAnyPublisher()
    }
}

// MARK: - Private function

private extension PersonalInfoViewModel {

    func bind(api: UserInfoAPIPrototype) {

        api
            .result
            .subscribe(onNext: {
                [weak self] result in
                switch result {
                case .success(let model):
                    self?.model = model
                case .failure(let error):
                    assert(false, "\(error)")
                }
            })
            .disposed(by: disposeBag)

        api.fetch()
    }
}
