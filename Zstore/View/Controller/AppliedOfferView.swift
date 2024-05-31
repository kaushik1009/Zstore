//
//  AppliedOfferView.swift
//  Zstore
//
//  Created by kaushik on 28/05/24.
//

import Foundation
import UIKit

protocol AppliedOfferViewDelegate {
    func adjustProductTableViewHeight()
}

class AppliedOfferView: UIButton {
    
    private let crossImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = UIColor(red: .random(in: 1...255)/255, green: .random(in: 1...255)/255, blue: .random(in: 1...255)/255, alpha: .random(in: 1...255)/255)
        return imageView
    }()
    
    var offerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var delegate: AppliedOfferViewDelegate?

    init(title: String) {
        super.init(frame: .zero)
        setupUI(with: title)
        NotificationCenter.default.addObserver(self, selector: #selector(applyOffer(notification:)),name: NSNotification.Name(rawValue: "ApplyOffer"), object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver("RemoveOffer")
    }

    private func setupUI(with title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        offerLabel.text = title
        offerLabel.font = .systemFont(ofSize: 13, weight: .medium)
        let tapGestureRecognizerForRemovingOffer = UITapGestureRecognizer(target: self, action: #selector(crossTapped))
        crossImageView.addGestureRecognizer(tapGestureRecognizerForRemovingOffer)
        crossImageView.isUserInteractionEnabled = true
        addSubview(crossImageView)
        addSubview(offerLabel)
        NSLayoutConstraint.activate([
            crossImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            crossImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            crossImageView.widthAnchor.constraint(equalToConstant: 16),
            crossImageView.heightAnchor.constraint(equalToConstant: 16),
            offerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            offerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func applyOffer(notification: Notification) {
        self.isHidden = false
        self.isUserInteractionEnabled = true
        offerLabel.text = "Applied: \(notification.userInfo?["selectedOffer"] ?? "")"
        offerLabel.textColor = UIColor(red: .random(in: 1...255)/255, green: .random(in: 1...255)/255, blue: .random(in: 1...255)/255, alpha: 1)
    }
    
    @objc func crossTapped() {
        self.isHidden = true
        self.isUserInteractionEnabled = false
        delegate?.adjustProductTableViewHeight()
        NotificationCenter.default.post(name: NSNotification.Name("RemoveOffer"),
                                        object: nil, userInfo: nil)
    }
}
