//
//  UserInfoAPI.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

private struct RequestTargetType: GUTargetType {

    typealias ResponseType = UserModel

    // Parameters
    let name: String?

    var path: String {

        guard let name = name else { return "user" }

        return "users" + "/" + name
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }
}

protocol UserInfoAPIPrototype {

    var result: Observable<Result<UserModel, ResponseError>> { get }

    func fetch(name: String)
    func fetch()
}

struct UserInfoAPI: UserInfoAPIPrototype {

    var result: Observable<Result<UserModel, ResponseError>> { _result.asObservable() }

    func fetch(name: String) {
        send(name: name)
    }

    func fetch() {
        send(name: nil)
    }

    private func send(name: String?) {
        MoyaProvider<RequestTargetType>(plugins: [TokenPlugin()]).send(
            request: RequestTargetType(name: name)
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

    private let _result = PublishRelay<Result<UserModel, ResponseError>>()
}
