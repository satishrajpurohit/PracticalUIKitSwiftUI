//
//  AssignmentViewModel.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import Foundation

// MARK: - AssignmentListDelegate
/// A protocol that defines methods for reloading cat images and cat breed list.
/// This protocol is intended to be implemented by any class that wants to handle the reloading of data.
protocol CatListDelegate: AnyObject {
    func reloadCatImages()
    func reloadCatBreedList()
}

// MARK: - CatViewModel
/// The view model for managing and fetching cat-related data such as images and breeds.
class CatViewModel {
    private let networkManager = NetworkManager()
    private let dataDecoder = DataDecoder()
    
    var catImages: [CatImage] = []
    var catBreeds: [CatBreed] = []
    var filteredBreeds: [CatBreed] = [CatBreed]()
    private weak var delegate: CatListDelegate?
    
    init(catListView: ViewController) {
        self.delegate = catListView
    }
    
    // MARK: - Fetch Cat Images
    /// Fetches cat images from the API and updates the `catImages` property
    func fetchCatImages() {
        guard let url = URL(string: APIConstants.catImagesURL) else { return }
        networkManager.fetchData(from: url) { [weak self] data, error in
            if let error = error {
                // Show an error message to the user
                print("Error fetching cat images: \(error.localizedDescription)")
                return
            }
            
            // Handle empty or invalid data
            guard let data = data else {
                print("No data received or data is empty.")
                return
            }
            
            // Try to decode the data
            if let decodedImages: [CatImage] = self?.dataDecoder.decode(data, to: [CatImage].self) {
                DispatchQueue.main.async {
                    self?.catImages = decodedImages
                    self?.delegate?.reloadCatImages()
                }
            } else {
                // Handle decoding failure
                print("Failed to decode cat images.")
            }
        }
    }
    
    // MARK: - Fetch Cat Breeds
    /// Fetches cat breeds from the API and updates the `catBreeds` property
    func fetchCatBreeds(selectedBreedPage: Int = 0) {
        guard let url = URL(string: APIConstants.catBreedsURL(page: selectedBreedPage)) else { return }
        self.catBreeds.removeAll()
        self.delegate?.reloadCatBreedList()
        networkManager.fetchData(from: url) { [weak self] data, error in
            
            if let error = error {
                // Show an error message to the user
                print("Error fetching cat breeds: \(error.localizedDescription)")
                return
            }
            
            // Handle empty or invalid data
            guard let data = data else {
                print("No data received or data is empty.")
                return
            }
            
            // Try to decode the data
            if let decodedBreeds: [CatBreed] = self?.dataDecoder.decode(data, to: [CatBreed].self) {
                DispatchQueue.main.async {
                    self?.catBreeds = decodedBreeds
                    self?.filteredBreeds = decodedBreeds
                    self?.delegate?.reloadCatBreedList()
                }
            } else {
                // Handle decoding failure
                print("Failed to decode cat breeds.")
            }
        }
    }
}

extension CatViewModel {
    
    func searchBreeds(searchValue: String) {
        if searchValue.isEmpty {
            filteredBreeds = catBreeds
        } else {
            filteredBreeds = catBreeds.filter { breed in
                breed.name.lowercased().contains(searchValue.lowercased())
            }
        }
        self.delegate?.reloadCatBreedList()
    }
}
