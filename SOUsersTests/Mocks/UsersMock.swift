//
//  UsersMock.swift
//  SOUsers
//
//  Created by Will Renton on 05/09/2025.
//

import Foundation
@testable import SOUsers

extension [User] {
    static var mockUsers: [User] = [
        .mockUser,
        .mockUserTwo,
        .mockUserThree
    ]
}

extension User {
    static var mockUser = User(
        id: 1,
        username: "Jane Doe",
        profilePicture: URL(string: "https://example.com/avatar1.png"),
        reputationScore: 14500
    )
    
    static var mockUserTwo = User(
        id: 2,
        username: "John Smith",
        profilePicture: URL(string: "https://example.com/avatar2.png"),
        reputationScore: 9800
    )
    
    static var mockUserThree = User(
        id: 3,
        username: "Alice Johnson",
        profilePicture: URL(string: "https://example.com/avatar3.png"),
        reputationScore: 17300
    )
}
