//
//  UsersResponseDTO.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

struct UsersResponseDTO: Codable {
    let items: [UserDTO]

    enum CodingKeys: String, CodingKey {
        case items
    }
    
    struct UserDTO: Codable {
        let accountId: Int
        let displayName: String
        let profileImage: String
        let reputation: Int
        
        enum CodingKeys: String, CodingKey {
            case accountId = "account_id"
            case displayName = "display_name"
            case profileImage = "profile_image"
            case reputation
        }
    }
}
