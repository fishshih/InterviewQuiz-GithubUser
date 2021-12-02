//
//  GUTargetType.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation
import Moya

protocol DecodableResponseTargetType: TargetType {

  associatedtype ResponseType: Codable
}

protocol GUTargetType: DecodableResponseTargetType {

    var decisions: [Decision] { get }
}

extension GUTargetType {

    var baseURL: URL {

        guard
            let url = URL(string: "https://github.com")
        else {
            assert(false)
        }

        return url
    }

    var headers: [String: String]? {
        ["Accept": "application/json"]
    }

    var decisions: [Decision] {
        [
            ResponseStatusCodeDecision(),
            ParseResultDecision(),
        ]
    }
}

