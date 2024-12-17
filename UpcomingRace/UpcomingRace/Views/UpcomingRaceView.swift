//
//  UpcomingRaceView.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import SwiftUI

/*
 This is the content view for the app.
 */
struct UpcomingRaceView: View {
    private enum Constants {
        static let title: String = "Upcoming Race"
        static let imageSideLength: CGFloat = 36
    }

    @StateObject private var viewModel: UpcomingRaceViewModel

    init(apiClient: UpcomingRaceAPIClientProtocol) {
        _viewModel = StateObject(wrappedValue: UpcomingRaceViewModel(apiClient: apiClient))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                CategorySelectorView(
                    selectedCategories: viewModel.selectedRaceCategories) { category in
                        viewModel.selectCategory(category)
                    }
                switch viewModel.viewState {
                case .loading:
                    ProgressView()
                case .failure(let error):
                    VStack {
                        Text("Error")
                            .font(.title3)
                        Text(error.localizedDescription)
                            .font(.caption)
                    }
                case .success(let races):
                    ForEach(races) { race in
                        HStack {
                            TimerView(seconds: race.advertisedStart.seconds)
                            VStack(alignment: .leading) {
                                Text(race.meetingName)
                                    .bold()
                                    .font(.title3)
                                Text("Race No. \(race.raceNumber)")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                Spacer()
                            }
                            .accessibilityLabel(Text("Race number \(race.raceNumber), Meeting Name \(race.meetingName)"))
                            Spacer()
                            Image(race.categoryID.name.lowercased())
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.red)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.imageSideLength, height: Constants.imageSideLength)
                                .accessibilityLabel(Text("\(race.categoryID.name) Category"))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                        Divider()
                    }

                }
            }
            .navigationTitle(Constants.title)
            .toolbarBackground(.visible)
            .toolbarBackground(.red)
            .task {
                await viewModel.fetchRaces()
            }
        }
    }
}

#Preview {
    UpcomingRaceView(apiClient: UpcomingRaceAPIClient())
}
