//
//  CollectionNFTCell.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 13.09.2026.
//

import UIKit

final class CollectionNFTCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CollectionNFTCell"
    
    private let ratingStarSide: CGFloat = 12
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .favoritesNotActive), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .cartNotAdded), for: .normal)
        button.tintColor = UIColor(resource: .ypBlack)
        button.addTarget(self, action: #selector(cartButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        
        let infoStackView = UIStackView()
        infoStackView.alignment = .center
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        
        contentStackView.addArrangedSubview(ratingStackView)
        contentStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(textStackView)
        infoStackView.addArrangedSubview(cartButton)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(priceLabel)
        
        return contentStackView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor(resource: .ypBlack)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .medium10
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayoutAndConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    @objc
    private func favoriteButtonDidTapped() {
        print("favorite button did tapped")
        // TODO: Implement favorite update
    }
    
    @objc
    private func cartButtonDidTapped() {
        print("cart button did tapped")
        // TODO: Implement cart update
    }
    
    func configure(with nft: Nft) {
        titleLabel.text = nft.name.capitalized
        priceLabel.text = "\(nft.price) ETH"
        
        configureRating(nft.rating)
        
        if let imageURL = nft.images.first {
            nftImageView.kf.setImage(with: imageURL)
        }
    }
    
    private func setupLayoutAndConstraints() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(contentStackView)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func configureRating(_ rating: Int) {
        ratingStackView.arrangedSubviews.forEach {
            ratingStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        for index in 0..<5 {
            let imageView = UIImageView()
            
            if index < rating {
                imageView.image = UIImage(resource: .starActive)
            } else {
                imageView.image = UIImage(resource: .starNoActive)
            }
            
            imageView.widthAnchor.constraint(equalToConstant: ratingStarSide).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: ratingStarSide).isActive = true
            
            ratingStackView.addArrangedSubview(imageView)
        }
        
        let spacer = UIView()
        ratingStackView.addArrangedSubview(spacer)
    }
}

