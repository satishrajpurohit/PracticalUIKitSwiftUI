//
//  SearchBarCell.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import UIKit

// MARK: - SearchDelegate Protocol
/// A protocol that defines the methods required for delegating search queries.
protocol SearchDelegate: AnyObject {
    func searchQuery(searchValue: String)
}

// MARK: - SearchBarCell Class
class SearchBarCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var tfSearch: UITextField!
    
    // MARK: - Properties
    weak var delegate: SearchDelegate?
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

// MARK: - UITextFieldDelegate
extension SearchBarCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        self.delegate?.searchQuery(searchValue: updatedText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder()
        return true
    }
}
