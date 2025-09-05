//
//  UsersAPIMock.swift
//  SOUsers
//
//  Created by Will Renton on 05/09/2025.
//

@testable import SOUsers

class UsersAPIMock: UsersAPIProtocol {
    var fetchAllUsersResult: Result<[User], Error> = .success([])
    
    func fetchAllUsers() async throws -> [User] {
        return try fetchAllUsersResult.get()
    }
}
