//
//  User.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

struct User: Identifiable {
    let id: Int
    let userName: String
    let profilePicture: URL
    let reputationScore: Int
}
