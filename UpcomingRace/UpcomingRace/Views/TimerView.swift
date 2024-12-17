//
//  TimerView.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import SwiftUI

/*
 This is the timer view that shows a countdown timer.
 */

struct TimerView: View {
    private enum Constants {
        static let sideLength: CGFloat = 64
        static let cornerRadius: CGFloat = 8
    }

    var seconds: Double
    var action: () -> Void = { }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { _ in
            HStack(spacing: .zero) {
                Text(Date(timeIntervalSince1970: seconds) > Date() ? "" : "-")
                Text(Date(timeIntervalSince1970: seconds), style: .timer)
                    .accessibilityLabel("\(seconds) seconds to expire")
            }
            .foregroundStyle(Date(timeIntervalSince1970: seconds) > Date() ? .black : .red)
            .frame(width: Constants.sideLength, height: Constants.sideLength)
            .background(Date(timeIntervalSince1970: seconds) > Date() ? .red : .black)
            .cornerRadius(Constants.cornerRadius)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TimerView(seconds: Date().timeIntervalSince1970)
}
