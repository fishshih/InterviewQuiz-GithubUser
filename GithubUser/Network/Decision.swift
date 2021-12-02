//
//  Decision.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation
import Moya

enum ResponseError: Error {
    case parseError(error: Error)
    case badResponse(statusCode: Int)
    case unknownError(error: Error)
}

enum DecisionAction<T: GUTargetType> {
    case continueWith(response: Moya.Response)
    case restartWith(decisions: [Decision])
    case errored(error: ResponseError)
    case done(value: T.ResponseType)
}

protocol Decision {

    func shouldApply<T: GUTargetType>(
        request: T,
        response: Moya.Response
    ) -> Bool

    func apply<T: GUTargetType>(
        request: T,
        response: Moya.Response,
        done closure: @escaping (DecisionAction<T>) -> Void
    )
}

fileprivate let decoder = JSONDecoder()

struct ResponseStatusCodeDecision: Decision {

    enum ServiceError: Error {
        case error(code: Int)
    }

    func shouldApply<T: GUTargetType>(
        request: T,
        response: Moya.Response
    ) -> Bool {
        return !(200 ..< 300).contains(response.statusCode)
    }

    func apply<T: GUTargetType>(
        request: T,
        response: Moya.Response,
        done closure: @escaping (DecisionAction<T>) -> Void
    ) {

        let statusCode = response.statusCode

        closure(.errored(error: .badResponse(statusCode: statusCode)))
    }
}

struct ParseResultDecision: Decision {

    func shouldApply<T: GUTargetType>(
        request: T,
        response: Moya.Response
    ) -> Bool { true }

    func apply<T: GUTargetType>(
        request: T,
        response: Moya.Response,
        done closure: @escaping (DecisionAction<T>) -> Void
    ) {

        do {
            let responseData = try decoder.decode(T.ResponseType.self, from: response.data)
            closure(.done(value: responseData))
        } catch {
            closure(.errored(error: .parseError(error: error)))
        }
    }
}

