//
//  OAuthModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation

struct OAuthModel: Codable {

    let token: String

    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
