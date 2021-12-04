// 
//  UserInfoViewModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation
import Combine

// MARK: - Reaction

enum UserInfoViewModelReaction {
    case dismiss
}

// MARK: - Prototype

protocol UserInfoViewModelInput {
    func dismiss()
}

protocol UserInfoViewModelOutput {
    var avatarURLString: AnyPublisher<String, Never> { get }
    var name: AnyPublisher<String, Never> { get }
    var bio: AnyPublisher<String?, Never> { get }
    var infoItems: AnyPublisher<[UserInfoItemModel], Never> { get }
}

protocol UserInfoViewModelPrototype {
    var input: UserInfoViewModelInput { get }
    var output: UserInfoViewModelOutput { get }
}

// MARK: - View model

class UserInfoViewModel: UserInfoViewModelPrototype {

    let reaction = PassthroughSubject<UserInfoViewModelReaction, Never>()

    var input: UserInfoViewModelInput { self }
    var output: UserInfoViewModelOutput { self }

    init(model: UserModel) {
        self.model = model
    }

    @Published private var model: UserModel?
}

// MARK: - Input & Output

extension UserInfoViewModel: UserInfoViewModelInput {

    func dismiss() {
        reaction.send(.dismiss)
    }
}

extension UserInfoViewModel: UserInfoViewModelOutput {

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

    var bio: AnyPublisher<String?, Never> {
        modelPublisher.map(\.bio).eraseToAnyPublisher()
    }

    var infoItems: AnyPublisher<[UserInfoItemModel], Never> {
        modelPublisher
            .map {
                [
                    .init(image: .system(name: "person.fill"), value: $0.login),
                    .init(image: .system(name: "location.fill"), value: $0.location),
                    .init(image: .system(name: "link"), value: $0.bio),
                    .init(image: .system(name: "envelope.fill"), value: $0.email)
                ]
            }
            .map {
                $0.filter { $0.value != nil }
            }
            .eraseToAnyPublisher()
    }
}
