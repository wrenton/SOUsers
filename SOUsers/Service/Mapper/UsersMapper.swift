//
//  UsersMapper.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

extension User {
    static func from(dto: UsersResponseDTO.UserDTO) -> User {
        .init(
             id: dto.accountId,
             username: dto.displayName,
             profilePicture: URL(string: dto.profileImage) ,
             reputationScore: dto.reputation
         )
    }
}
