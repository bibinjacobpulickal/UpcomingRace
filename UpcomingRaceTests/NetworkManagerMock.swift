//
//  NetworkManagerMock.swift
//  UpcomingRaceTests
//
//  Created by Bibin Jacob Pulickal on 17/12/2024.
//

import Foundation
@testable import UpcomingRace

class NetworkManagerMock: NetworkManagerProtocol {

    var didCallSendRequest: Bool = false
    var didCallSendRequestWithRequest: Request?
    var sendResponse: UpcomingRaceModel?
    var sendFailure = UpcomingRaceError.serverError
    func send<T: Decodable>(_ request: Request) async -> Result<T, Error> {
        didCallSendRequest = true
        didCallSendRequestWithRequest = request
        if let sendResponse, let response = sendResponse as? T {
            return .success(response)
        } else {
            return .failure(sendFailure)
        }
    }
}
