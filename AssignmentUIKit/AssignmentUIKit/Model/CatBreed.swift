//
//  CatBreed.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import Foundation

struct CatBreed: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let image: CatBreedImage?

    struct CatBreedImage: Codable {
        let url: String
    }
}
