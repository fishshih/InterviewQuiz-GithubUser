//
//  GUUserDefaults.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation

class GUUserDefaults {

    private struct Keys {
        static let token = "tokenStorage"
    }
}

extension GUUserDefaults {

    class func save(token: String) {
        UserDefaults.standard.set(token, forKey: Keys.token)
    }

    class func getToken() -> String? {
        UserDefaults.standard.string(forKey: Keys.token)
    }
}
