//
//  StatisticViewController.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import UIKit

// MARK: - StatisticViewController
/// The view controller responsible for displaying statistics related to the visible cat breeds,
/// such as the total number of visible items and the top 3 most frequent characters in breed names.
class StatisticViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTotalCount: UILabel!
    @IBOutlet weak var lblFirstCharacter: UILabel!
    @IBOutlet weak var lblSecondCharacter: UILabel!
    @IBOutlet weak var lblThirdCharacter: UILabel!
    
    // MARK: - Properties
    fileprivate var statisticsProvider: StatisticsProvider = StatisticViewModel()
    var visibleBreeds: [CatBreed] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

// MARK: - Configure View
/// Extension to `StatisticViewController` to configure the view with statistics.
extension StatisticViewController {
    
    /// Configures the UI with the total visible items and the top 3 frequent characters.
    func configureView() {
        let totalCount = statisticsProvider.getTotalCount(visibleBreeds: visibleBreeds)
        let topThreeFrequentCharacters = statisticsProvider.getTop3FrequentCharacters(visibleBreeds: visibleBreeds)
        
        lblTotalCount.text = "Total Visible Items: \(totalCount)"

        if let characters = topThreeFrequentCharacters {
            if characters.count > 0 {
                lblFirstCharacter.text = "\(characters[0].0): \(characters[0].1)"
            }
            if characters.count > 1 {
                lblSecondCharacter.text = "\(characters[1].0): \(characters[1].1)"
            }
            if characters.count > 2 {
                lblThirdCharacter.text = "\(characters[2].0): \(characters[2].1)"
            }
        }
    }
    
}
