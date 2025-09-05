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
    private var usersAPI: UsersAPIMock
    private var followingAPI: FollowersAPIMock
    private var viewModel: UsersViewModel
    
    init() {
        usersAPI = UsersAPIMock()
        followingAPI = FollowersAPIMock()
        viewModel = UsersViewModel(
            usersAPI: usersAPI,
            followingAPI: followingAPI
        )
    }
    
    @Test
    func fetchUsers_successState() async throws {
        let mockUsers: [User] = .mockUsers
        usersAPI.fetchAllUsersResult = .success(mockUsers)
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.users.isEmpty)
        
        await viewModel.fetchUsers()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.users == mockUsers)
    }
    
    @Test
    func fetchUsers_failureState() async throws {
        let mockError = MockError.any
        usersAPI.fetchAllUsersResult = .failure(mockError)
        
        await viewModel.fetchUsers()
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.users.isEmpty)
        #expect(viewModel.errorMessage == "Oops, something went wrong. Please try again!")
    }
    
    @Test
    func toggleFollowingStatus_followsUser() throws {
        let userID = 101
        #expect(!followingAPI.isFollowing(for: userID))

        viewModel.toggleFollowingStatus(for: userID)

        #expect(followingAPI.followUserCalled)
        #expect(!followingAPI.unfollowUserCalled)
        #expect(followingAPI.isFollowing(for: userID))
    }

    @Test
    func toggleFollowingStatus_unfollowsUser() throws {
        let userID = 202
        followingAPI.followUser(for: userID)
        #expect(followingAPI.isFollowing(for: userID))
       
        viewModel.toggleFollowingStatus(for: userID)
       
        #expect(followingAPI.unfollowUserCalled)
        #expect(!followingAPI.isFollowing(for: userID))
    }

    @Test
    func isFollowing_returnsCorrectStatus() throws {
        let followedID = 303
        let notFollowedID = 404
        followingAPI.followUser(for: followedID)

        #expect(viewModel.isFollowing(for: followedID))
        #expect(!viewModel.isFollowing(for: notFollowedID))
    }
}

private enum MockError: Error {
    case any
}
