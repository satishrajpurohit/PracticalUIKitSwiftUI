//
//  StatisticView.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import SwiftUI

// MARK: - StatisticView
/// A view to display statistics related to visible cat breeds, like the total count and most frequent characters.
struct StatisticView: View {
    var visibleBreeds: [CatBreed]
    @StateObject private var statisticViewModel = StatisticViewModel(statisticsCalculator: CharacterFrequencyService())
   
    var body: some View {
        Text("Total Visible Items: \(visibleBreeds.count)")
            .task {
                statisticViewModel.visibleBreeds = visibleBreeds
            }
        let topThreeFrequentBreadCharacters = statisticViewModel.getTop3FrequentCharacters()
        
        ForEach(topThreeFrequentBreadCharacters, id: \.0) { char, count in
            Text("\(char): \(count)")
                .font(.headline)
        }
    }
}

