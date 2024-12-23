//
//  StatisticViewModel.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import Foundation


protocol StatisticsProvider {
    func getTop3FrequentCharacters(visibleBreeds: [CatBreed]) -> [(Character, Int)]?
    func getTotalCount(visibleBreeds: [CatBreed]) -> Int
}

// MARK: - StatisticViewModel
/// A view model for calculating statistics related to visible cat breeds,
/// such as determining the most frequent characters across all breed names.
class StatisticViewModel: StatisticsProvider {
    
    var visibleBreeds: [CatBreed] = []
    
    // MARK: - Get Top 3 Frequent Characters
    /// Calculates the top 3 most frequent characters across all breed names.
    /// - Parameter visibleBreeds: A list of cat breeds to analyze.
    /// - Returns: An array of tuples, each containing a character and its frequency count, sorted by frequency.
    func getTop3FrequentCharacters(visibleBreeds: [CatBreed]) -> [(Character, Int)]? {
        let breedNames = visibleBreeds.map { $0.name }
        let allCharacters = breedNames.joined().filter { $0.isLetter }
        var characterCount: [Character: Int] = [:]
        for char in allCharacters {
            characterCount[char, default: 0] += 1
        }
        let sortedCharacters = characterCount.sorted { $0.value > $1.value }.prefix(3)
        return Array(sortedCharacters)
    }
    
    func getTotalCount(visibleBreeds: [CatBreed]) -> Int {
        return visibleBreeds.count
    }
    
}
