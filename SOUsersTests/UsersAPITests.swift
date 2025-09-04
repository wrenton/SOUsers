//
//  UsersAPITests.swift
//  SOUsers
//
//  Created by Renton, William on 04/09/2025.
//

import Testing
import Foundation
@testable import SOUsers

// Class to find the test bundle
class UsersAPITests {
    @Test
    func fetchAllUsers_whenSuccessful_returnsMappedUsers() async throws {
        let data = try Data.from(json: "users")
        let networking = MockNetworking(data: data)
        let api = UsersAPI(networking: networking)

        let users = try await api.fetchAllUsers()

        #expect(users.count == 20)
        #expect(users[0].id == 11683)
        #expect(users[0].username == "Jon Skeet")
        #expect(users[0].profilePicture == URL(string: "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG"))
        #expect(users[0].reputationScore == 1515958)
        #expect(users[1].username == "VonC")
    }

    @Test
    func fetchAllUsers_whenNetworkFails_throwsError() async {
        let expectedError = URLError(.notConnectedToInternet)
        let networking = MockNetworking(error: expectedError)
        let api = UsersAPI(networking: networking)

        await #expect(throws: (any Error).self) {
            _ = try await api.fetchAllUsers()
        }
    }

    @Test
    func fetchAllUsers_withMalformedData_throwsDecodingError() async {
        let malformedJSON = "{\"items\":[{\"display_name\":\"Test\"}]}".data(using: .utf8)!
        let networking = MockNetworking(data: malformedJSON)
        let api = UsersAPI(networking: networking)

        await #expect(throws: UsersAPIError.self) {
            _ = try await api.fetchAllUsers()
        }
    }

    @Test
    func fetchAllUsers_withEmptyResponse_returnsEmptyArray() async throws {
        let emptyJSON = "{\"items\":[]}".data(using: .utf8)!
        let networking = MockNetworking(data: emptyJSON)
        let api = UsersAPI(networking: networking)

        let users = try await api.fetchAllUsers()

        #expect(users.isEmpty)
    }
}

extension Data {
    static func from(json: String) throws -> Self {
        let bundle = Bundle(for: UsersAPITests.self)
        let path = bundle.path(forResource: json, ofType: "json")
        return try Data(contentsOf: URL(fileURLWithPath: path!))
    }
}
