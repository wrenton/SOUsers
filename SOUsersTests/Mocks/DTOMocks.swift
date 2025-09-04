//
//  DTOMocks.swift
//  SOUsers
//
//  Created by Renton, William on 04/09/2025.
//

@testable import SOUsers

extension UsersResponseDTO {
    static var mockResponseDTO = UsersResponseDTO(
        items: [
            .firstMockDTO,
            .secondMockDTO
        ]
    )
}

extension UsersResponseDTO.UserDTO {
    static var firstMockDTO = UsersResponseDTO.UserDTO(
        accountId: 1,
        displayName: "User One",
        profileImage: "https://example.com/1.png",
        reputation: 10
    )
    static var secondMockDTO = UsersResponseDTO.UserDTO(
        accountId: 2,
        displayName: "User Two",
        profileImage: "https://example.com/2.png",
        reputation: 20
    )
}
