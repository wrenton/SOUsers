//
//  UsersMapperTests.swift
//  SOUsers
//
//  Created by Renton, William on 04/09/2025.
//

import Testing
import Foundation
@testable import SOUsers

struct UsersMapperTests {
    @Test
    func mapFromDTO_withValidData_createsUsers()  throws {
        let responseDTO: UsersResponseDTO = .mockResponseDTO

        let users: [User] = .from(dto: responseDTO)

        #expect(users.count == 2)
        #expect(users[0].id == 1)
        #expect(users[0].username == "User One")
        #expect(users[0].reputationScore == 10)
        #expect(users[0].profilePicture == URL(string: "https://example.com/1.png"))
        #expect(users[1].id == 2)
        #expect(users[1].username == "User Two")
        #expect(users[1].reputationScore == 20)
        #expect(users[1].profilePicture == URL(string: "https://example.com/2.png"))
    }

    @Test
    func mapFromDTO_withEmptyItems_createsEmptyUsersArray() {
        let responseDTO = UsersResponseDTO(items: [])

        let users = [User].from(dto: responseDTO)

        #expect(users.isEmpty)
    }
}
