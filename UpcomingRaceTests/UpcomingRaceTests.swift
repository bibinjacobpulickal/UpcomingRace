//
//  UpcomingRaceTests.swift
//  UpcomingRaceTests
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import Foundation
import Testing
@testable import UpcomingRace

@Suite class UpcomingRaceViewModelTests {

    private let apiClient = UpcomingRaceAPIClientMock()
    private var sut: UpcomingRaceViewModel!

    init() {
        sut = UpcomingRaceViewModel(apiClient: apiClient)
    }

    @Test
    func testFetchRacesSuccess() async throws {
        let upcomingRaces = UpcomingRaceModel.mockModel(count: 5)
        let expectedRaces: [RaceSummary] = Array(upcomingRaces.raceSummaries.values).sorted { $0.raceNumber < $1.raceNumber }
        apiClient.upcomingRaces = upcomingRaces
        await sut.fetchRaces()
        #expect(apiClient.didCallFetchRaces)
        #expect(apiClient.didCallFetchRacesWithCount == 5)
        #expect(sut.viewState == .success(races: expectedRaces))
    }

    @Test
    func testFetchRacesFailure() async throws {
        await sut.fetchRaces()
        #expect(apiClient.didCallFetchRaces)
        #expect(apiClient.didCallFetchRacesWithCount == 5)
        #expect(sut.viewState == .failure(error: .serverError))
    }

    @Test(arguments: RaceCategory.allCases)
    func testSelectCategory(_ category: RaceCategory) async throws {
        sut.selectCategory(category)
        #expect(sut.selectedRaceCategories.contains(category))
    }
}

extension UpcomingRaceModel {

    static func mockModel(count: Int = Int.random(in: 5...50)) -> UpcomingRaceModel {
        let races = Array(1...count).map { id in
            RaceSummary(id: "\(id)",
                        raceName: "Race \(id)",
                        meetingName: "Meeting \(id)",
                        raceNumber: id,
                        categoryID: RaceCategory.allCases.randomElement() ?? .horse,
                        advertisedStart: .init(seconds: Date().timeIntervalSince1970 + Double.random(in: 0...1000)))
        }
        let raceSummaries = races.reduce(into: [:]) { $0[$1.id] = $1 }
        return .init(nextToGoIDS: races.map(\.id), raceSummaries: raceSummaries)
    }
}
