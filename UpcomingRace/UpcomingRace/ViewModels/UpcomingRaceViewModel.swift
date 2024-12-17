//
//  UpcomingRaceViewModel.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import SwiftUI

enum UpcomingRaceViewState: Equatable {
    case loading
    case failure(error: UpcomingRaceError)
    case success(races: [RaceSummary])

    static func == (lhs: UpcomingRaceViewState, rhs: UpcomingRaceViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case let (.failure(lhsError), .failure(rhsError)): return lhsError == rhsError
        case let (.success(lhsRaces), .success(rhsRaces)): return lhsRaces == rhsRaces
        default: return false
        }
    }
}

@Observable class UpcomingRaceViewModel: ObservableObject {

    private let apiClient: UpcomingRaceAPIClientProtocol

    var viewState: UpcomingRaceViewState = .loading

    private var races = [RaceSummary]() {
        didSet {
            viewState = .success(races: races)
        }
    }
    private(set) var selectedRaceCategories = [RaceCategory]()
    private var nextToGoIds = [String]()
    private var raceSummaries = [String: RaceSummary]()
    private var fetchCount = 5
    private var removeExpiredWorkItem: DispatchWorkItem?

    init(apiClient: UpcomingRaceAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchRaces() async {
        do {
            viewState = .loading
            let upcomingRaceModel = try await apiClient.fetchRaces(count: fetchCount)
            nextToGoIds = upcomingRaceModel.nextToGoIDS
            raceSummaries = upcomingRaceModel.raceSummaries
            updateRaces()
        } catch {
            viewState = .failure(error: .serverError)
        }
    }

    /*
     This method handles selection of Race Category.
     */
    func selectCategory(_ category: RaceCategory) {
        selectedRaceCategories.contains(category) ? selectedRaceCategories.removeAll(where: { $0 == category }) : selectedRaceCategories.append(category)
        updateRaces()
    }

    /*
     This method handles filtering and displaying the races according to selected category and expiry.
     */
    private func updateRaces() {
        withAnimation {
            races = Array(nextToGoIds
                .compactMap({ raceSummaries[$0] })
                .filter({ selectedRaceCategories.isEmpty ? true : selectedRaceCategories.contains($0.categoryID) })
                .filter({ Int($0.advertisedStart.seconds) - Int(Date().timeIntervalSince1970) > -60 })
                .prefix(5)
            )
        }
        if races.count < 5 {
            fetchCount += 5 - races.count
            Task {
                await fetchRaces()
            }
        } else {
            removeExpiredRaces()
        }
    }

    /*
     This method handles removal of races after expiry.
     */
    private func removeExpiredRaces() {
        guard let firstRace = races.first else { return }
        let secondsTillExpiry = firstRace.advertisedStart.seconds + 60 - Date().timeIntervalSince1970
        if secondsTillExpiry > 0 {
            updateRacesAfter(secondsTillExpiry)
        } else {
            updateRaces()
        }
    }

    /*
     This method calls update races after seconds.

     - Parameter seconds: The number seconds to wait before
     */
    private func updateRacesAfter(_ seconds: Double) {
        removeExpiredWorkItem?.cancel()
        removeExpiredWorkItem = DispatchWorkItem { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.updateRaces()
            }
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + seconds, execute: removeExpiredWorkItem!)
    }
}
