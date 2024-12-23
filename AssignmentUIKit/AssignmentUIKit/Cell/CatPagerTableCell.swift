//
//  CatPagerTableCell.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import UIKit

protocol SelectedBreedPageDelegate: AnyObject {
    func SelectedBreedPage(selectedBreedPage: Int)
}

// MARK: - CatPagerTableCell
/// Custom table view cell for displaying a horizontal collection view of cat images, along with a page control.
class CatPagerTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var catPageControl: UIPageControl!
    @IBOutlet weak var gridCatPager: UICollectionView!
    
    // MARK: - Properties
    var catImages: [CatImage] = []
    private var gridViewHeight = 180.0
    private var gridHorizontalSpace = 32.0
    weak var selectedBreedPageDelegate: SelectedBreedPageDelegate?
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK: - Grid Reload Method
/// Extensions to handle the grid view updates.
extension CatPagerTableCell {
    func reloadGridPager() {
        self.gridCatPager.reloadData()
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension CatPagerTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let horizontalCatPagerCell = gridCatPager.dequeueReusableCell(withReuseIdentifier: "HorizontalCatPagerCell", for: indexPath) as? HorizontalCatPagerCell else { return UICollectionViewCell() }
        let objCatImage = catImages[indexPath.row]
        horizontalCatPagerCell.setupView()
        horizontalCatPagerCell.loadImage(from: objCatImage.url)
        return horizontalCatPagerCell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - gridHorizontalSpace, height: gridViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        catPageControl.currentPage = page
        self.selectedBreedPageDelegate?.SelectedBreedPage(selectedBreedPage: page)
    }
}
