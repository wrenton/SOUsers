//
//  UsersViewModel.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    
    private let usersAPI: UsersAPIProtocol
    
    init(usersAPI: UsersAPIProtocol = UsersAPI()) {
        self.usersAPI = usersAPI
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
}
