//
//  UpcomingRaceAPIClientMock.swift
//  UpcomingRaceTests
//
//  Created by Bibin Jacob Pulickal on 17/12/2024.
//

import Foundation
@testable import UpcomingRace

class UpcomingRaceAPIClientMock: UpcomingRaceAPIClientProtocol {

    var didCallFetchRaces: Bool = false
    var didCallFetchRacesWithCount: Int = 0
    var upcomingRaces: UpcomingRaceModel?
    func fetchRaces(count: Int) async throws -> UpcomingRaceModel {
        didCallFetchRaces = true
        didCallFetchRacesWithCount = count
        if let upcomingRaces {
            return upcomingRaces
        } else {
            throw UpcomingRaceError.serverError
        }
    }
}
