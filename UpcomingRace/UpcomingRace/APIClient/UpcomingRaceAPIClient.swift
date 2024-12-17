//
//  UpcomingRaceAPIClient.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import Foundation

protocol UpcomingRaceAPIClientProtocol {
    func fetchRaces(count: Int) async throws -> UpcomingRaceModel
}

actor UpcomingRaceAPIClient: UpcomingRaceAPIClientProtocol {

    private var requestModel = UpcomingRaceRequestModel()
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    /*
     This method fetches the races from the API via GET method.
     */
    func fetchRaces(count: Int = 5) async throws -> UpcomingRaceModel {
        requestModel.fetchCount = count
        let result: Result<UpcomingRaceModel, Error> = await networkManager.send(requestModel)
        switch result {
        case .success(let raceData):
            return raceData
        case .failure(let error):
            throw error
        }
    }
}

struct UpcomingRaceRequestModel: Request {
    var fetchCount = 0
    var url: URL { URL(string: "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=\(fetchCount)")! }
}

enum UpcomingRaceError: Error, LocalizedError {
    case serverError

    var localizedDescription: String {
        switch self {
        case .serverError:
            return "There was an error fetching upcoming races"
        }
    }
}

