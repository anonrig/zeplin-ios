//
//  User.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Mapper

struct User: Mappable {
    let identifier: String
    let email: String
    let username: String
    let emotar: String?
    let avatar: String?
    
    init(map: Mapper) throws {
        try identifier = map.from("identifier")
        try email = map.from("email")
        try username = map.from("username")
        emotar = map.optionalFrom("emotar")
        avatar = map.optionalFrom("avatar")
    }
}

// MARK: - Helper functions
extension User {
    func getPrefix(maxLength: Int = 2, isUppercased: Bool = true) -> String {
        if isUppercased {
            return username.prefix(maxLength).uppercased()
        }
        return String(username.prefix(maxLength))
    }
}
