//
//  UserInfoItemModel.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation

struct UserInfoItemModel {

    enum ImageType {
        case system(name: String)
        case asset(name: String)
    }

    let image: ImageType
    let value: String?
}
