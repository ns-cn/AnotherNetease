//
//  User.swift
//  Yu (iOS)
//
//  Created by tangyujun on 2022/5/23.
//

import Foundation

// MARK: User Model and Sample Data
struct User: Identifiable{
    var id = UUID().uuidString
    var name: String
    var image: String
    var title: String
}
var users: [User] = [
    User(name: "1", image: "user1", title: "apple event is here")
]
