//
//  UserDefaultsMock.swift
//  SOUsers
//
//  Created by Will Renton on 05/09/2025.
//

import Foundation

class UserDefaultsMock: UserDefaults {
    private var mockStore: [String: Any] = [:]

    override func set(_ value: Any?, forKey key: String) {
        mockStore[key] = value
    }
    
    override func array(forKey key: String) -> [Any]? {
        return mockStore[key] as? [Any]
    }
}
