//
//  SWCell.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class SWCell: UICollectionViewCell {
    
    func configureCell<T: SWCategory> (_ swObject: T) {
        generateCellBackgroundView()
        
        let textLbl = UILabel()
        self.addSubview(textLbl)
        
        textLbl.textColor = UIColor.white
        textLbl.textAlignment = .center
        //set font size, number of lines, etc based on type
        if swObject.category == .starship || swObject.category == .vehicle {
            textLbl.numberOfLines = 0
            textLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
        
        textLbl.text = swObject.itemName
        
        textLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            textLbl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4.0),
            textLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4.0)
            ])
    }
    
    private func generateCellBackgroundView() {
        let cellBackgroundView = CellBackgroundView()
        self.addSubview(cellBackgroundView)
        
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            cellBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            cellBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }
}
