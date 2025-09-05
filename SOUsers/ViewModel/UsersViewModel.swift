//
//  UsersViewModel.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

class UsersViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    
    private let usersAPI: UsersAPIProtocol
    private let followingAPI: FollowersAPIProtocol
    
    init(
        usersAPI: UsersAPIProtocol = UsersAPI(),
        followingAPI: FollowersAPIProtocol = FollowersAPI()
    ) {
        self.usersAPI = usersAPI
        self.followingAPI = followingAPI
    }
    
    func fetchUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let users = try await usersAPI.fetchAllUsers()
            self.users = users
        } catch {
            errorMessage = "Oops, something went wrong. Please try again!"
        }
        
        isLoading = false
    }
    
    func toggleFollowingStatus(for userID: Int) {
        if isFollowing(for: userID) {
            followingAPI.unfollowUser(for: userID)
        } else {
            followingAPI.followUser(for: userID)
        }
    }
    
    func isFollowing(for userID: Int) -> Bool {
        followingAPI.isFollowing(for: userID)
    }
}
