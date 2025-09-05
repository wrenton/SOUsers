//
//  FollowersAPI.swift
//  SOUsers
//
//  Created by Will Renton on 05/09/2025.
//

import Foundation

protocol FollowersAPIProtocol {
    func followUser(for userID: Int)
    func unfollowUser(for userID: Int)
    func fetchAllFollowedUsers() -> [Int]
    func isFollowing(for userID: Int) -> Bool
}

class FollowersAPI: FollowersAPIProtocol {
    private let userDefaults: UserDefaults
    private let key = "followedUserIDs"
    
    init(userDefaults: UserDefaults = UserDefaults()) {
        self.userDefaults = userDefaults
    }
    
    func followUser(for userID: Int) {
        var ids = fetchAllFollowedUsers()
        if !ids.contains(userID) {
            ids.append(userID)
            userDefaults.set(ids, forKey: key)
        }
    }
    
    func unfollowUser(for userID: Int) {
        var ids = fetchAllFollowedUsers()
        if let index = ids.firstIndex(of: userID) {
            ids.remove(at: index)
            userDefaults.set(ids, forKey: key)
        }
    }
    
    func fetchAllFollowedUsers() -> [Int] {
        userDefaults.array(forKey: key) as? [Int] ?? []
    }
    
    func isFollowing(for userID: Int) -> Bool {
        fetchAllFollowedUsers().contains(userID)
    }
}
