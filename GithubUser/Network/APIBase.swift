//
//  APIBase.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation
import Moya

extension MoyaProvider where Target: GUTargetType {

    func send<T: GUTargetType>(
        request: T,
        decisions: [Decision]? = nil,
        handler: @escaping (Result<T.ResponseType, Error>) -> Void
    ) {

        guard let requestTarget = request as? Target else {
            assert(false)
        }

        self.request(requestTarget) {
            result in

            switch result {
            case .success(let response):
                self.handleDecision(
                    request,
                    response: response,
                    decisions: decisions ?? request.decisions,
                    handler: handler
                )

            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    func handleDecision<T: GUTargetType>(
        _ request: T,
        response: Moya.Response,
        decisions: [Decision],
        handler: @escaping (Result<T.ResponseType, Error>) -> Void
    ) {

        guard !decisions.isEmpty else {
            fatalError("No decision left but did not reach a stop.")
        }

        var decisions = decisions
        let current = decisions.removeFirst()

        guard
            current.shouldApply(request: request, response: response)
        else {
            handleDecision(
                request,
                response: response,
                decisions: decisions,
                handler: handler
            )
            return
        }

        current
            .apply(
                request: request,
                response: response
            ) {
                action in

                switch action {

                case .continueWith(response: let response):
                    self.handleDecision(
                        request,
                        response: response,
                        decisions: decisions,
                        handler: handler
                    )

                case .restartWith(decisions: let decisions):
                    self.send(
                        request: request,
                        decisions: decisions,
                        handler: handler
                    )

                case .errored(error: let error):

                    /*
                    print("😎 ", request.path, "  error = ", error)
                    */

                    handler(.failure(error))

                case .done(value: let value):
                    handler(.success(value))
                }
            }
    }
}

