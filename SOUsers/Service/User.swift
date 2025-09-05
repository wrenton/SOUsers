//
//  User.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

struct User: Equatable {
    let id: Int
    let username: String
    let profilePicture: URL?
    let reputationScore: Int
}
