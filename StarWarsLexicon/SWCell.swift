//
//  SWCell.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

class SWCell: UICollectionViewCell {
    
    let textLbl = UILabel()
    let activitySpinner = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        generateCellBackgroundView()
        
        configureTextLbl()
        textLbl.isHidden = true
        
        configureActivitySpinner()
        activitySpinner.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLbl.isHidden = true
        activitySpinner.startAnimating()
    }

    //    func configureCell<T: SWCategory> (_ item: T) {
    //Turning of generics for testing purposes
    func configureCell<T: NSManagedObject> (_ item: T) where T: SWCategory {
        activitySpinner.stopAnimating()
        textLbl.isHidden = false
        
        if item.category == "starship" || item.category == "vehicle" {
            textLbl.numberOfLines = 0
            textLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
        
        textLbl.text = item.itemName
    }
    
    private func configureTextLbl() {
        self.addSubview(textLbl)

        textLbl.textColor = UIColor.white
        textLbl.textAlignment = .center
        
        textLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            textLbl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4.0),
            textLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4.0)
            ])
    }
    
    private func configureActivitySpinner() {
        self.addSubview(activitySpinner)
        activitySpinner.translatesAutoresizingMaskIntoConstraints = false
        
        activitySpinner.activityIndicatorViewStyle = .whiteLarge
        //May be possible to refactor this so that these constraints can be reused for text label
        NSLayoutConstraint.activate([
            activitySpinner.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            activitySpinner.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
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
