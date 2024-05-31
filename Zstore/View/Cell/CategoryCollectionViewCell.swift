//
//  CategoryCollectionViewCell.swift
//  Zstore
//
//  Created by kaushik on 25/05/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCollectionViewCell"
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ indexPath: IndexPath, _ storeData: Store?) {
        self.label.text = " \(storeData?.category[indexPath.row].name ?? "")  "
        self.label.backgroundColor = .clear
        self.label.layer.borderColor = UIColor.lightGray.cgColor
        self.label.textColor = UIColor.darkGray
    }
    
    func selectedState() {
        self.label.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
        self.label.layer.borderColor = UIColor.systemOrange.cgColor
        self.label.textColor = UIColor.systemOrange
    }
    
    func unselectedState() {
        self.label.backgroundColor = .clear
        self.label.layer.borderColor = UIColor.lightGray.cgColor
        self.label.textColor = UIColor.darkGray
    }
}
