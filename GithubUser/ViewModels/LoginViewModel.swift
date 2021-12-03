// 
//  LoginViewModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/2.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

// MARK: - Reaction

enum LoginViewModelReaction {
    case loginSuccess
}

// MARK: - Prototype

protocol LoginViewModelInput {
    func loginSuccess(code: String)
}

protocol LoginViewModelOutput {
    var url: AnyPublisher<URL, Never> { get }
}

protocol LoginViewModelPrototype {
    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

// MARK: - View model

class LoginViewModel: LoginViewModelPrototype {

    let reaction = PassthroughSubject<LoginViewModelReaction, Never>()

    var input: LoginViewModelInput { self }
    var output: LoginViewModelOutput { self }

    init(api: AuthAPIPrototype?) {

        self.api = api

        buildURL()

        guard let api = self.api else { return }

        bind(api: api)
    }

    private let clientID = "450e752e195fd0b2d028"
    private let clientSecrets = "eda7875c63539707b756736b92fdde7785413581"

    private let api: AuthAPIPrototype?

    @Published private var urlPublisher: URL?

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension LoginViewModel: LoginViewModelInput {

    func loginSuccess(code: String) {
        api?.send(clientID: clientID, clientSecrets: clientSecrets, code: code)
    }
}

extension LoginViewModel: LoginViewModelOutput {

    var url: AnyPublisher<URL, Never> {
        urlPublisher
            .publisher
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private function

private extension LoginViewModel {

    func bind(api: AuthAPIPrototype) {

        api
            .result
            .subscribe(onNext: {
                [weak self] result in
                switch result {
                case .success(let model):

                    GUUserDefaults.save(token: model.token)
                    self?.reaction.send(.loginSuccess)

                case .failure(let error):
                    assert(false, "\(error)")
                }
            })
            .disposed(by: disposeBag)
    }

    func buildURL() {

        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/authorize"

        let urlString = urlComponents.url?.absoluteString

        urlComponents.queryItems = [
            .init(name: "client_id", value: clientID),
            .init(name: "scope", value: "user"),
            .init(name: "allow_signup", value: "false"),
            .init(name: "redirect_uri", value: urlString)
        ]

        guard let url = urlComponents.url else { return }

        urlPublisher = url
    }
}
