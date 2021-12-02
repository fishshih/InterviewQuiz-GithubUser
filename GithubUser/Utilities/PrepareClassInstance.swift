//
//  PrepareClassInstance.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/3.
//

import Foundation

infix operator -->

/// Prepare class instance
func --> <T>(object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
