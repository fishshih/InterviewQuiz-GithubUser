//
//  UsersListAPI.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

private struct RequestTargetType: GUTargetType {

    typealias ResponseType = [UserListElementModel]

    var path: String {
        "users"
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }
}

protocol UsersListAPIPrototype {

    var result: Observable<Result<[UserListElementModel], ResponseError>> { get }

    func fetch()
}

struct UsersListAPI: UsersListAPIPrototype {

    var result: Observable<Result<[UserListElementModel], ResponseError>> { _result.asObservable() }

    func fetch() {
        MoyaProvider<RequestTargetType>(plugins: [TokenPlugin()]).send(
            request: RequestTargetType()
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

    private let _result = PublishRelay<Result<[UserListElementModel], ResponseError>>()
}

