//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import UIKit
import Kingfisher

final class CartItemCell: UITableViewCell, ReuseIdentifying {
    
    var onCartButtonTap: (() -> Void)?
    
    let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .segmentActive
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .left
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let priceSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .segmentActive
        label.text = NSLocalizedString("Cart.item.price.subtitle", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.onCartButtonTap?()
        }
        
        let button = UIButton(type: .system, primaryAction: action)
        let image = UIImage(resource: .delete)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupView() {
        selectionStyle = .none
        
        contentView.addSubview(nftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(priceSubtitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 44),
            cartButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -8),
            
            ratingImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            priceSubtitleLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 12),
            priceSubtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceSubtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceSubtitleLabel.bottomAnchor, constant: 2),
            priceLabel.bottomAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: -8),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
    }
    
    func configure(with title: String, price: String, rating: Int) {
        titleLabel.text = title
        priceLabel.text = price
        setRating(with: rating)
    }
    
    private func setRating(with rating: Int) {
        if rating >= 0 && rating <= 5 {
            ratingImageView.image = UIImage(named: "Rating \(rating)")
            ratingImageView.isHidden = false
        } else {
            ratingImageView.isHidden = true
        }
    }
}
