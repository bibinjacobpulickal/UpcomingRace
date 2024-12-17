//
//  UpcomingRaceApp.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import SwiftUI

@main
struct UpcomingRaceApp: App {
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared

    var body: some Scene {
        WindowGroup {
            UpcomingRaceView(apiClient: UpcomingRaceAPIClient(networkManager: networkManager))
        }
    }
}
