//
//  BreedListCell.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/02.
//

import UIKit

class BreedListCell: UITableViewCell {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
}

extension BreedListCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
