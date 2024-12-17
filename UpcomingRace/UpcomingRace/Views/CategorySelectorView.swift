//
//  CategorySelectorView.swift
//  UpcomingRace
//
//  Created by Bibin Jacob Pulickal on 16/12/2024.
//

import SwiftUI

/*
 This is the category selector view for selecting the race category.
 */
struct CategorySelectorView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let imageSideLength: CGFloat = 24
        static let accessibilityLabel: String = "Select Race Category"
    }

    var selectedCategories: [RaceCategory]
    var completion: ((RaceCategory) -> Void)

    var body: some View {
        VStack {
            HStack {
                ForEach(RaceCategory.allCases, id: \.rawValue) { category in
                    Button {
                        completion(category)
                    } label: {
                        HStack {
                            Image(category.name.lowercased())
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(selectedCategories.contains(category) ? .black : .red)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.imageSideLength, height: Constants.imageSideLength)
                            Text(category.name)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .foregroundStyle(selectedCategories.contains(category) ? .black : .red)
                        .background {
                            if selectedCategories.contains(category) {
                                Color.red
                                    .cornerRadius(Constants.cornerRadius)
                                    .overlay {
                                        RoundedCorner(radius: Constants.cornerRadius)
                                            .stroke(Color.red, lineWidth: 1)
                                    }
                            } else {
                                Color.clear
                                    .cornerRadius(Constants.cornerRadius)
                                    .overlay {
                                        RoundedCorner(radius: Constants.cornerRadius)
                                            .stroke(Color.red, lineWidth: 1)
                                    }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            Divider()
        }
        .padding(.vertical, 8)
        .accessibilityLabel(Constants.accessibilityLabel)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        .init(UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                           cornerRadii: CGSize(width: radius, height: radius)).cgPath)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CategorySelectorView(selectedCategories: [.harness], completion: { _ in })
}
