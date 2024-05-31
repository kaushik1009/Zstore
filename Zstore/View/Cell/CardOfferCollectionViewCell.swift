//
//  CardOfferCollectionViewCell.swift
//  Zstore
//
//  Created by kaushik on 27/05/24.
//

import UIKit

class CardOfferCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCollectionViewCell"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    let offerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    let offerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var homeViewModel = HomeViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(offerLabel)
        contentView.addSubview(offerImageView)
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: offerImageView.leadingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            offerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            offerLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            offerLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            offerImageView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: 16),
            offerImageView.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            offerImageView.widthAnchor.constraint(equalToConstant: 80),
            offerImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ indexPath: IndexPath, _ storeData: Store?) {
        self.titleLabel.text = storeData?.card_offers[indexPath.row].card_name
        self.descriptionLabel.text = storeData?.card_offers[indexPath.row].offer_desc
        self.offerLabel.text = storeData?.card_offers[indexPath.row].max_discount
        self.applyGradient(indexPath.row)
        self.homeViewModel.fetchImage(from: URL(string: storeData?.card_offers[indexPath.row].image_url ?? "")!, self.offerImageView)
    }
    
    func applyGradient(_ indexPath: Int) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = indexPath == 0 ? [UIColor(red: 26/255, green: 126/255, blue: 218/255, alpha: 1).cgColor, UIColor(red: 43/255, green: 209/255, blue: 255/255, alpha: 1).cgColor] : ( indexPath == 1 ? [UIColor(red: 255/255, green: 166/255, blue: 30/255, alpha: 1).cgColor, UIColor(red: 253/255, green: 82/255, blue: 97/255, alpha: 1).cgColor] : [UIColor(red: 240/255, green: 35/255, blue: 116/255, alpha: 1).cgColor, UIColor(red: 245/255, green: 26/255, blue: 236/255, alpha: 1).cgColor])
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
