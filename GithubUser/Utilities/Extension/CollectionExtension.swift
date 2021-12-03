//
//  CollectionExtension.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
