//
//  UsersViewModelTests.swift
//  SOUsers
//
//  Created by Will Renton on 05/09/2025.
//

import Testing
import Foundation
@testable import SOUsers

struct UsersViewModelTests {
    @Test
    func fetchUsers_successState() async throws {
        let mockUsersAPI = UsersAPIMock()
        let mockFollowingAPI = FollowersAPIMock()
        let viewModel = UsersViewModel(
            usersAPI: mockUsersAPI,
            followingAPI: mockFollowingAPI
        )
        
        let mockUsers: [User] = .mockUsers
        mockUsersAPI.fetchAllUsersResult = .success(mockUsers)
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.users.isEmpty)
        
        await viewModel.fetchUsers()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.users == mockUsers)
    }
    
    @Test
    func fetchUsers_failureState() async throws {
        let mockUsersAPI = UsersAPIMock()
        let mockFollowingAPI = FollowersAPIMock()
        let viewModel = UsersViewModel(
            usersAPI: mockUsersAPI,
            followingAPI: mockFollowingAPI
        )
        
        let mockError = MockError.any
        mockUsersAPI.fetchAllUsersResult = .failure(mockError)
        
        await viewModel.fetchUsers()
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.users.isEmpty)
        #expect(viewModel.errorMessage == "Oops, something went wrong. Please try again!")
    }
    
    @Test
    func toggleFollowingStatus_followsUser() throws {
        let mockUsersAPI = UsersAPIMock()
        let mockFollowingAPI = FollowersAPIMock()
        let viewModel = UsersViewModel(
            usersAPI: mockUsersAPI,
            followingAPI: mockFollowingAPI
        )

        let userID = 101
        #expect(!mockFollowingAPI.isFollowing(for: userID))

        viewModel.toggleFollowingStatus(for: userID)

        #expect(mockFollowingAPI.followUserCalled)
        #expect(!mockFollowingAPI.unfollowUserCalled)
        #expect(mockFollowingAPI.isFollowing(for: userID))
    }

    @Test
    func toggleFollowingStatus_unfollowsUser() throws {
        let mockUsersAPI = UsersAPIMock()
        let mockFollowingAPI = FollowersAPIMock()
        let viewModel = UsersViewModel(
            usersAPI: mockUsersAPI,
            followingAPI: mockFollowingAPI
        )

        let userID = 202
        mockFollowingAPI.followUser(for: userID)
        #expect(mockFollowingAPI.isFollowing(for: userID))
       
        viewModel.toggleFollowingStatus(for: userID)
       
        #expect(mockFollowingAPI.unfollowUserCalled)
        #expect(!mockFollowingAPI.isFollowing(for: userID))
    }

    @Test
    func isFollowing_returnsCorrectStatus() throws {
        let mockUsersAPI = UsersAPIMock()
        let mockFollowingAPI = FollowersAPIMock()
        let viewModel = UsersViewModel(
            usersAPI: mockUsersAPI,
            followingAPI: mockFollowingAPI
        )

        let followedID = 303
        let notFollowedID = 404
        mockFollowingAPI.followUser(for: followedID)

        #expect(viewModel.isFollowing(for: followedID))
        #expect(!viewModel.isFollowing(for: notFollowedID))
    }
}

private enum MockError: Error {
    case any
}
