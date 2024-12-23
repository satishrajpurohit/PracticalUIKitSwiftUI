//
//  CatViewModel.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import Foundation

// MARK: - CatViewModel
/// The view model for managing and fetching cat-related data such as images and breeds.
class CatViewModel: ObservableObject {
    @Published var catImages: [CatImage] = []
    @Published var catBreeds: [CatBreed] = []
    @Published var filteredBreeds: [CatBreed] = []
    
    private let networkManager = NetworkManager()
    private let dataDecoder = DataDecoder()
    
    // MARK: - Fetch Cat Images
    /// Fetches cat images from the API and updates the `catImages` property
    func fetchCatImages() {
        guard let url = URL(string: APIConstants.catImagesURL) else { return }
        networkManager.fetchData(from: url) { [weak self] catImageData, error in
            if let error = error {
                // Show an error message to the user
                print("Error fetching cat images: \(error.localizedDescription)")
                return
            }
            
            // Handle empty or invalid data
            guard let catImage = catImageData else {
                print("No data received or data is empty.")
                return
            }
            
            // Try to decode the data
            if let catImagesData: [CatImage] = self?.dataDecoder.decode(catImage, to: [CatImage].self) {
                DispatchQueue.main.async {
                    self?.catImages = catImagesData
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
        DispatchQueue.main.async {
            self.catBreeds.removeAll()
        }
        networkManager.fetchData(from: url) { [weak self] breedData, error in
            
            if let error = error {
                // Show an error message to the user
                print("Error fetching cat breeds: \(error.localizedDescription)")
                return
            }
            
            // Handle empty or invalid data
            guard let breedData = breedData else {
                print("No data received or data is empty.")
                return
            }
            
            // Try to decode the data
            if let breeds: [CatBreed] = self?.dataDecoder.decode(breedData, to: [CatBreed].self) {
                DispatchQueue.main.async {
                    self?.catBreeds = breeds
                    self?.filteredBreeds = breeds
                }
            } else {
                // Handle decoding failure
                print("Failed to decode cat breeds.")
            }
        }
    }
    
    func searchBreeds(searchValue: String) {
        if searchValue.isEmpty {
            filteredBreeds = catBreeds
        } else {
            filteredBreeds = catBreeds.filter { breed in
                breed.name.lowercased().contains(searchValue.lowercased())
            }
        }
    }
    
}
