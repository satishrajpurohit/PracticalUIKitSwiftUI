//
//  ViewController.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import UIKit

// MARK: - ViewController
/// The main view controller for displaying a list of cat breeds and images, with a floating button to show statistics.
class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var btnFloatingButton: UIButton!
    @IBOutlet weak var tblCatList: UITableView!
    
    // MARK: - Properties
    fileprivate var catListViewModel: CatViewModel?
    fileprivate var headerHeight: CGFloat = 60
    fileprivate var totalSection: Int = 2
    fileprivate var floatingButtonRadius = 30.0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Actions
    @IBAction func onClickFloatingButton(_ sender: UIButton) {
        let statisticVC: StatisticViewController = self.storyboard?.instantiateViewController(withIdentifier: "StatisticViewController") as! StatisticViewController
        statisticVC.visibleBreeds = catListViewModel?.filteredBreeds ?? []
        self.present(statisticVC, animated: true, completion: nil)
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: headerHeight))
        let headerCell = tblCatList.dequeueReusableCell(withIdentifier: "SearchBarCell") as! SearchBarCell
        headerCell.frame = headerView.bounds
        headerCell.delegate = self
        headerView.addSubview(headerCell)
        return section ==  0 ? UIView() : headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : catListViewModel?.filteredBreeds.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            guard let catCell = tblCatList.dequeueReusableCell(withIdentifier: "CatPagerTableCell", for: indexPath) as? CatPagerTableCell else { return UITableViewCell() }
            catCell.catImages = catListViewModel?.catImages ?? []
            catCell.reloadGridPager()
            catCell.catPageControl.numberOfPages = catListViewModel?.catImages.count ?? 0
            catCell.selectedBreedPageDelegate = self
            catCell.gridCatPager.collectionViewLayout.invalidateLayout()
            return catCell
        }
        guard let catCell = tblCatList.dequeueReusableCell(withIdentifier: "ListOfCatCell", for: indexPath) as? ListOfCatCell else { return UITableViewCell() }
        if let objCatBreeds = catListViewModel?.filteredBreeds[indexPath.row] {
            catCell.setUpData(catBreed: objCatBreeds)
        }
        return catCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    
}

// MARK: - View Configuration
/// Extensions to configure and set up the view controller.
extension ViewController {
    func configureView() {
        catListViewModel = CatViewModel(catListView: self)
        // Set the reachability handler to react to changes in network status
        ReachabilityManager.shared.setReachabilityHandler { isConnected in
            if isConnected {
                self.catListViewModel?.fetchCatImages()
                self.catListViewModel?.fetchCatBreeds()
            }
        }
        btnFloatingButton.layer.cornerRadius = floatingButtonRadius
        tblCatList.sectionHeaderTopPadding = 0
    }
    
}

// MARK: - AssignmentListDelegate
/// Delegate methods to reload data in the view controller after fetching cat breeds and images.
extension ViewController: CatListDelegate {
    func reloadCatImages() {
        tblCatList.reloadData()
    }
    
    func reloadCatBreedList() {
        DispatchQueue.main.async {
            self.tblCatList.reloadData()
        }
    }
    
}

// MARK: - SearchDelegate
/// Delegate methods for handling the search functionality.
extension ViewController: SearchDelegate {
    
    func searchQuery(searchValue: String) {
        self.catListViewModel?.searchBreeds(searchValue: searchValue)
    }
    
}

extension ViewController: SelectedBreedPageDelegate {
    func SelectedBreedPage(selectedBreedPage: Int) {
        self.catListViewModel?.fetchCatBreeds(selectedBreedPage: selectedBreedPage)
    }
}
