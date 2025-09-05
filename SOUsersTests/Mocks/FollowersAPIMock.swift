//
//  FollowersAPIMock.swift
//  SOUsers
//
//  Created by Will Renton on 05/09/2025.
//

@testable import SOUsers

class FollowersAPIMock: FollowersAPIProtocol {
    private var followedIDs = Set<Int>()
    var followUserCalled = false
    var unfollowUserCalled = false
    
    func followUser(for userID: Int) {
        followUserCalled = true
        followedIDs.insert(userID)
    }
    
    func unfollowUser(for userID: Int) {
        unfollowUserCalled = true
        followedIDs.remove(userID)
    }
    
    func fetchAllFollowedUsers() -> [Int] {
        return Array(followedIDs)
    }
    
    func isFollowing(for userID: Int) -> Bool {
        return followedIDs.contains(userID)
    }
}
