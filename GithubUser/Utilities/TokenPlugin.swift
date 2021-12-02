//
//  TokenPlugin.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation
import Moya

struct TokenPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        guard let token = GUUserDefaults.getToken() else { return request }

        var request = request

        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")

        return request
    }
}
