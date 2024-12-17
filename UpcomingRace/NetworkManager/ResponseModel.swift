//
//  ResponseModel.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import Foundation

// MARK: - ResponseModel
struct ResponseModel<T: Codable>: Codable {
    let status: Int
    let data: T
    let message: String
}
