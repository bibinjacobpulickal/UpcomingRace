//
//  NetworkManager.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func send<T: Codable>(_ request: Request) async -> Result<T, Error>
}

final class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func send<T: Codable>(_ request: Request) async -> Result<T, Error> {
        do {
            let (data, _) = try await urlSession.data(from: request.url)
            let response = try JSONDecoder().decode(ResponseModel<T>.self, from: data)
            return .success(response.data)
        } catch {
            return .failure(error)
        }
    }
}

protocol Request {
    var url: URL { get }
}
