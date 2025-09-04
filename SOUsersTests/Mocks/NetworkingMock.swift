//
//  NetworkingMock.swift
//  SOUsers
//
//  Created by Renton, William on 04/09/2025.
//

import Foundation
@testable import SOUsers

private enum MockError: Error {
    case networkFailure
}

struct MockNetworking: NetworkingProtocol {
    var data: Data?
    var error: Error?

    init(data: Data? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }

    func fetch(from request: any Request) async throws -> Data {
        if let error = error {
            throw error
        }
        guard let data = data else {
            return Data()
        }
        return data
    }
}
