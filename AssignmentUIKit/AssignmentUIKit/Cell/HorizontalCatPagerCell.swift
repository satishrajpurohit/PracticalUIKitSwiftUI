//
//  HorizontalCatPagerCell.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import UIKit

// MARK: - HorizontalCatPagerCell
/// Custom UICollectionViewCell to display a single cat image in a horizontal scrolling view with an activity indicator for image loading.
class HorizontalCatPagerCell: UICollectionViewCell {
   
    // MARK: - Outlets
    @IBOutlet weak var imgCat: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var imageDownloadTask: URLSessionDataTask?
    private var imgCatCornerRadius = 10.0
    
    // MARK: - Reuse Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        imgCat.image = nil
        activityIndicator.stopAnimating()
    }
}

// MARK: - Cell Setup and Image Loading
extension HorizontalCatPagerCell {
    
    func setupView() {
        activityIndicator.hidesWhenStopped = true
        imgCat.layer.cornerRadius = imgCatCornerRadius
    }
    
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        activityIndicator.startAnimating()
        imageDownloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                if error != nil {
                    self.imgCat.image = UIImage(systemName: "photo.fill")
                    self.imgCat.backgroundColor = .gray.withAlphaComponent(0.2)
                } else if let data = data, let image = UIImage(data: data) {
                    self.imgCat.image = image
                }
            }
        }
        imageDownloadTask?.resume()
    }
}

