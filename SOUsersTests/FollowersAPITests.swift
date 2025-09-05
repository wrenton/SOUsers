//
//  FollowersAPITests.swift
//  SOUsers
//
//  Created by Will Renton on 05/09/2025.
//

import Testing
@testable import SOUsers

struct FollowersAPITests {
    @Test
    func followUser_storesSuccessfully() throws {
        let userDefaults = UserDefaultsMock()
        let api = FollowersAPI(userDefaults: userDefaults)
        
        let userID = 123
        #expect(!api.isFollowing(for: userID))
        
        api.followUser(for: userID)
        
        #expect(api.isFollowing(for: userID))
        let ids = userDefaults.array(forKey: "followedUserIDs") as? [Int] ?? []
        #expect(ids.count == 1)
        #expect(ids.contains(userID))
    }
    
    @Test
    func unfollowUser_updatesSuccessfully() throws {
        let userDefaults = UserDefaultsMock()
        let api = FollowersAPI(userDefaults: userDefaults)
        
        let userID = 456
        api.followUser(for: userID)
        #expect(api.isFollowing(for: userID))
        
        api.unfollowUser(for: userID)
        #expect(!api.isFollowing(for: userID))
        let ids = userDefaults.array(forKey: "followedUserIDs") as? [Int] ?? []
        #expect(ids.count == 0)
        #expect(!ids.contains(userID))
    }
    
    @Test
    func fetchAllFollowedUsers_fetchesSuccessfully() throws {
        let userDefaults = UserDefaultsMock()
        let api = FollowersAPI(userDefaults: userDefaults)
        
        let ids = [10, 20, 30, 40]
        userDefaults.set(ids, forKey: "followedUserIDs")

        let fetchedIDs = api.fetchAllFollowedUsers()

        #expect(fetchedIDs == ids)
    }
    
    @Test
    func checkIfFollowingUser_returnsExpected() throws {
        let userDefaults = UserDefaultsMock()
        let api = FollowersAPI(userDefaults: userDefaults)
        
        let followedID = 789
        let notFollowedID = 987
        userDefaults.set([followedID], forKey: "followedUserIDs")

        #expect(api.isFollowing(for: followedID))
        #expect(!api.isFollowing(for: notFollowedID))
    }
}
