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
    case loginSuccess(code: String)
}

// MARK: - Prototype

protocol LoginViewModelInput {
    func loginSuccess(code: String)
}

protocol LoginViewModelOutput {
//    var url: Observable<URL> { get }
    var url: AnyPublisher<URL, Never> { get }
}

protocol LoginViewModelPrototype {
    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

// MARK: - View model

class LoginViewModel: LoginViewModelPrototype {

    var input: LoginViewModelInput { self }
    var output: LoginViewModelOutput { self }

    init() {
        buildURL()
    }

    private let clientID = "450e752e195fd0b2d028"
    private let clientSecrets = "eda7875c63539707b756736b92fdde7785413581"

    @Published private var urlPublisher: URL?
    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension LoginViewModel: LoginViewModelInput {

    func loginSuccess(code: String) {

        guard let url = URL(string: "https://github.com/login/oauth/access_token") else { return }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let parameters = [
            "client_id": clientID,
            "client_secret": clientSecrets,
            "code": code
        ]

        request.httpBody = try? JSONSerialization
            .data(
                withJSONObject: parameters,
                options: .prettyPrinted
            )

        let task = URLSession
            .shared
            .dataTask(with: request) { (data, response, error) in

                if let error = error {
                    print("😎 error = ", error)
                }

                guard
                    let data = data,
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])

                else {
                    print("😎 fail")
                    return
                }

                print("😎 jsonData = ", jsonData)
        }

        task.resume()
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

    func buildURL() {

        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/authorize"

        urlComponents.queryItems = [
            .init(name: "client_id", value: clientID),
            .init(name: "scope", value: "user"),
            .init(name: "allow_signup", value: "false"),
        ]

        guard let url = urlComponents.url else { return }

        urlPublisher = url
    }
}
