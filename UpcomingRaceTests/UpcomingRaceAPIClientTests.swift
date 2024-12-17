//
//  UpcomingRaceAPIClientTests.swift
//  UpcomingRaceTests
//
//  Created by Bibin Jacob Pulickal on 17/12/2024.
//

import Testing
@testable import UpcomingRace

@Suite
class UpcomingRaceAPIClientTests {

    private let networkManager = NetworkManagerMock()
    private var sut: UpcomingRaceAPIClient!

    init() async throws {
        sut = UpcomingRaceAPIClient(networkManager: networkManager)
    }

    @Test
    func testFetchRacesFailure() async throws {
        let result = try? await sut.fetchRaces(count: 1)
        #expect(networkManager.didCallSendRequest)
        #expect(networkManager.didCallSendRequestWithRequest?.url.absoluteString == "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=1")
        #expect(result == nil)
    }

    @Test
    func testFetchRacesSuccess() async throws {
        let response: UpcomingRaceModel = UpcomingRaceModel.mockModel()
        networkManager.sendResponse = response
        let result = try await sut.fetchRaces(count: 1)
        #expect(networkManager.didCallSendRequest)
        #expect(networkManager.didCallSendRequestWithRequest?.url.absoluteString == "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=1")
        #expect(result == response)
    }
}
