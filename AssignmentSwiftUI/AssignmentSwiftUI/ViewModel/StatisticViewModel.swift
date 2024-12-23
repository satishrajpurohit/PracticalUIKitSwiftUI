//
//  StatisticViewModel.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import Foundation

// MARK: - StatisticViewModel
/// A view model for calculating statistics related to visible cat breeds,
/// such as determining the most frequent characters across all breed names.
class StatisticViewModel: ObservableObject {
    @Published var visibleBreeds: [CatBreed] = []
    private var statisticsCalculator: StatisticsCalculable
    
    // Inject the statistics calculator dependency
    init(statisticsCalculator: StatisticsCalculable) {
        self.statisticsCalculator = statisticsCalculator
    }
    
    // Get the top 3 frequent characters
    func getTop3FrequentCharacters() -> [(Character, Int)] {
        let breedNames = visibleBreeds.map { $0.name }
        return statisticsCalculator.getTop3FrequentCharacters(from: breedNames)
    }
}

// Protocol for calculating statistics
protocol StatisticsCalculable {
    func getTop3FrequentCharacters(from breedNames: [String]) -> [(Character, Int)]
}

// Service class responsible for calculating statistics
class CharacterFrequencyService: StatisticsCalculable {
    func getTop3FrequentCharacters(from breedNames: [String]) -> [(Character, Int)] {
        let allBreedCharacters = breedNames.joined().filter { $0.isLetter }
        var breedCharacterCount: [Character: Int] = [:]
        
        for char in allBreedCharacters {
            breedCharacterCount[char, default: 0] += 1
        }
        
        let sortedBreedCharacters = breedCharacterCount.sorted { $0.value > $1.value }.prefix(3)
        return Array(sortedBreedCharacters)
    }
}
