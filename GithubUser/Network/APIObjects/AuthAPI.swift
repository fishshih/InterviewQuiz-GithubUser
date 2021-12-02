//
//  AuthAPI.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

private struct RequestTargetType: GUTargetType {

    typealias ResponseType = OAuthModel

    // Parameters
    let clientID: String
    let clientSecrets: String
    let code: String

    var path: String {
        "/login/oauth/access_token"
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestParameters(
            parameters: [
                "client_id": clientID,
                "client_secret": clientSecrets,
                "code": code
            ],
            encoding: URLEncoding.default
        )
    }
}

protocol AuthAPIPrototype {

    var result: Observable<Result<OAuthModel, ResponseError>> { get }

    func send(clientID: String, clientSecrets: String, code: String)
}

struct AuthAPI: AuthAPIPrototype {

    var result: Observable<Result<OAuthModel, ResponseError>> { _result.asObservable() }

    func send(clientID: String, clientSecrets: String, code: String) {
        MoyaProvider<RequestTargetType>().send(
            request: RequestTargetType(
                clientID: clientID,
                clientSecrets: clientSecrets,
                code: code
            )
        ) {
            switch $0 {
            case .success(let model):
                self._result.accept(.success(model))
            case .failure(let error):
                print("🛠 \(#fileID) API Error: ", error)
                let error = error as? ResponseError ?? .unknownError(error: error)
                self._result.accept(.failure(error))
            }
        }
    }

    private let _result = PublishRelay<Result<OAuthModel, ResponseError>>()
}

