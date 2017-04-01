//
//  UserProvider.swift
//  MVVM
//
//  Created by DaoNV on 3/16/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import RealmS

protocol UserProviderProtocol {
    let users: Result<User>
    func fetch() -> Self
    func update(completion: @escaping Completion) -> Self
}

class UserProvider: UserProviderProtocol {
    var users: [UserViewModel] = []

    @discardableResult
    func fetch() -> Self {
        return self
    }

    @discardableResult
    func update(completion: @escaping Completion) -> Self {
        return self
    }
}