//
//  ProductTableViewCell.swift
//  Zstore
//
//  Created by kaushik on 27/05/24.
//

import UIKit
import CoreData

class ProductTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProductTableViewCell"
    
    let allColors: [String: UIColor] = [
        "red": .red,
        "black": .black,
        "blue": .blue,
        "gray": .gray,
        "orange": .orange,
        "yellow": .yellow,
        "pink": .systemPink,
        "white": .white,
        "purple": .purple,
        "maroon": .magenta,
        "teal": .systemTeal,
        "green": .green
    ]
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 13
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let starRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(red: 230/255, green: 86/255, blue: 15/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let starRatingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(string: "₹0", attributes: [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ])
        label.attributedText = attributedString
        return label
    }()
    let savingsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 21/255, green: 140/255, blue: 91/255, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.clipsToBounds = true
        return view
    }()
    let savingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        return label
    }()
    let colorSwatchesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var homeViewModel = HomeViewModel()
    var percentage = 0
    var savings = 0.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(productImageView)
        contentView.addSubview(reviewCountLabel)
        contentView.addSubview(starRatingView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(colorSwatchesStackView)
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(savingsView)
        savingsView.addSubview(savingsLabel)
        originalPriceLabel.isHidden = true
        savingsView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(discountCalculation(notification:)),name: NSNotification.Name(rawValue: "DiscountCalculation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeOffer(notification:)),name: NSNotification.Name(rawValue: "RemoveOffer"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver("DiscountCalculation")
        NotificationCenter.default.removeObserver("RemoveOffer")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.widthAnchor.constraint(equalToConstant: 90),
            productImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            starRatingView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starRatingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            starRatingView.heightAnchor.constraint(equalToConstant: 20),
            
            reviewCountLabel.leadingAnchor.constraint(equalTo: starRatingView.trailingAnchor, constant: 5),
            reviewCountLabel.centerYAnchor.constraint(equalTo: starRatingView.centerYAnchor),

            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 5),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),

            colorSwatchesStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            colorSwatchesStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            colorSwatchesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            originalPriceLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 5),
            originalPriceLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 0),
            
            savingsView.leadingAnchor.constraint(equalTo: originalPriceLabel.trailingAnchor, constant: 4),
            savingsView.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 5),
            savingsView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 0),
            savingsView.heightAnchor.constraint(equalToConstant: 20),
            savingsView.widthAnchor.constraint(equalToConstant: 100),
            
            savingsLabel.centerXAnchor.constraint(equalTo: savingsView.centerXAnchor),
            savingsLabel.centerYAnchor.constraint(equalTo: savingsView.centerYAnchor),
            savingsLabel.leadingAnchor.constraint(equalTo: savingsView.leadingAnchor, constant: 10),
            savingsLabel.trailingAnchor.constraint(equalTo: savingsView.trailingAnchor, constant: -10)
        ])
    }
    
    func configure(_ product: Prod) {
        self.titleLabel.text = product.name
        self.reviewCountLabel.text = " (\(product.review_count))"
        self.priceLabel.text = "₹\(product.price)"
        originalPriceLabel.text = priceLabel.text
        self.starRatingLabel.text = "\(product.rating)"
        var desc = product.desc.replacingOccurrences(of: "**", with: "")
        self.descriptionLabel.text = desc
        self.colorSwatchesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.starRatingView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.calculateStars(product.rating)
        self.fillColorSwatches(product.colors ?? [])
        self.homeViewModel.fetchImage(from: URL(string: product.image_url)!, self.productImageView)
        if !originalPriceLabel.isHidden {
            savings = (((Double(percentage))/100) * product.price)
            self.priceLabel.text = "₹\(product.price - savings)"
            self.savingsLabel.text = "Save ₹\(Double(round(100 * savings) / 100))"
        }
    }
    
    func calculateStars(_ rating: Double) {
        starRatingView.addArrangedSubview(starRatingLabel)
        for number in 0..<5 {
            let starImageView = UIImageView(image: UIImage(named: "ic_star_filled"))
            let emptyImageView = UIImageView(image: UIImage(named: "ic_star_empty"))
            starImageView.contentMode = .scaleAspectFit
            if number >= Int(rating) {
                starRatingView.addArrangedSubview(emptyImageView)
            } else {
                starRatingView.addArrangedSubview(starImageView)
            }
        }
    }
    
    func fillColorSwatches(_ colors: [String]) {
        colors.forEach { color in
            let colorView = UIView()
            colorView.backgroundColor = allColors[color]
            colorView.layer.cornerRadius = 10
            colorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            colorSwatchesStackView.addArrangedSubview(colorView)
        }
    }
    
    @objc func discountCalculation(notification: Notification) {
        originalPriceLabel.isHidden = false
        savingsView.isHidden = false
        percentage = notification.userInfo?["discount"] as? Int ?? 0
    }
    
    @objc func removeOffer(notification: Notification) {
        originalPriceLabel.isHidden = true
        savingsView.isHidden = true
        percentage = 0
    }
}
