//
//  SortView.swift
//  Zstore
//
//  Created by kaushik on 28/05/24.
//

import Foundation
import UIKit

protocol SortViewDelegate {
    func sortApplied(_ sortBy: String)
}

class SortView: UIView {
    
    var ratingLabel: UIButton!
    var ratingCheckBox: UIButton!
    var ratingParentView: UIView!
    var priceLabel: UIButton!
    var priceCheckBox: UIButton!
    var priceParentView: UIView!
    var headerLabel: UILabel!
    var delegate: SortViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10

        headerLabel = UILabel()
        headerLabel.text = "Filter Order: From Top to Bottom"
        headerLabel.textAlignment = .center
        headerLabel.textColor = .gray
        headerLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally

        ratingLabel = createCheckboxButton(title: "Rating", imageName: "ic_rating")
        priceLabel = createCheckboxButton(title: "Price", imageName: "ic_dollar")
        ratingCheckBox = createCheckboxButton(title: "", imageName: "ic_check")
        priceCheckBox = createCheckboxButton(title: "", imageName: "ic_uncheck")
        
        ratingParentView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        ratingParentView.addSubview(ratingLabel)
        ratingParentView.addSubview(ratingCheckBox)
        ratingParentView.translatesAutoresizingMaskIntoConstraints = false
        
        priceParentView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        priceParentView.addSubview(priceLabel)
        priceParentView.addSubview(priceCheckBox)
        priceParentView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGestureRecognizerForPrice = UITapGestureRecognizer(target: self, action: #selector(priceTapped))
        let tapGestureRecognizerForRating = UITapGestureRecognizer(target: self, action: #selector(ratingTapped))
        ratingParentView.addGestureRecognizer(tapGestureRecognizerForRating)
        priceParentView.addGestureRecognizer(tapGestureRecognizerForPrice)
        
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(ratingParentView)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(priceParentView)

        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingCheckBox.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceCheckBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: self.ratingParentView.topAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: self.ratingParentView.leadingAnchor, constant: 4),
            ratingLabel.centerYAnchor.constraint(equalTo: self.ratingParentView.centerYAnchor),
            ratingCheckBox.topAnchor.constraint(equalTo: self.ratingParentView.topAnchor, constant: 4),
            ratingCheckBox.trailingAnchor.constraint(equalTo: self.ratingParentView.trailingAnchor, constant: -12),
            ratingCheckBox.centerYAnchor.constraint(equalTo: self.ratingParentView.centerYAnchor),
            priceLabel.topAnchor.constraint(equalTo: self.priceParentView.topAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: self.priceParentView.leadingAnchor, constant: 4),
            priceLabel.centerYAnchor.constraint(equalTo: self.priceParentView.centerYAnchor),
            priceCheckBox.topAnchor.constraint(equalTo: self.priceParentView.topAnchor, constant: 4),
            priceCheckBox.trailingAnchor.constraint(equalTo: self.priceParentView.trailingAnchor, constant: -12),
            priceCheckBox.centerYAnchor.constraint(equalTo: self.priceParentView.centerYAnchor)
        ])
    }
    
    private func createCheckboxButton(title: String, imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .orange
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        return button
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        return separator
    }

    @objc private func priceTapped(_ sender: UIGestureRecognizer) {
        ratingLabel.isSelected = false
        ratingCheckBox.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        priceCheckBox.setImage(UIImage(named: "ic_check"), for: .normal)
        delegate?.sortApplied("price")
    }
    
    @objc private func ratingTapped(_ sender: UIGestureRecognizer) {
        priceLabel.isSelected = false
        priceCheckBox.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        ratingCheckBox.setImage(UIImage(named: "ic_check"), for: .normal)
        delegate?.sortApplied("rating")
    }
}
