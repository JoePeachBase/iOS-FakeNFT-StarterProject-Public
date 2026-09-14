//
//  CollectionDetailHeaderView.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 12.09.2026.
//

import UIKit

final class CollectionDetailHeaderView: UICollectionReusableView {
    
    var onAuthorTap: (() -> Void)?
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorContainer)
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.setCustomSpacing(0, after: authorContainer)
        
        return stackView
    }()
    
    lazy var authorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(resource: .ypBlueUniversal), for: .normal)
        button.titleLabel?.font = .caption1
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(authorButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var authorContainer: UIStackView = {
        let container = UIStackView()
        container.spacing = 4
        container.alignment = .center
        container.distribution = .fill
        
        let authorTitleLabel = UILabel()
        authorTitleLabel.textColor = UIColor(resource: .ypBlack)
        authorTitleLabel.font = .caption2
        authorTitleLabel.text = NSLocalizedString("Collection.author.title", comment: "")
        authorTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        authorTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        container.addArrangedSubview(authorTitleLabel)
        container.addArrangedSubview(authorButton)
        container.addArrangedSubview(spacer)
        
        return container
    }()
    
    let coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        
        coverImageView.layer.cornerRadius = 12
        coverImageView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        return coverImageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .ypBlack)
        label.font = .headline3
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .ypBlack)
        label.font = .caption2
        label.numberOfLines = 0
        return label
    }()
    
    private let coverImageHeight: CGFloat = 310
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayoutAndConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(with collection: NFTCollection) {
        if let url = URL(string: collection.cover) {
            coverImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = collection.name.capitalized
        
        let description = collection.description
        descriptionLabel.text = description.prefix(1).uppercased() + description.dropFirst()
        
        authorButton.setTitle(collection.author, for: .normal)
        
    }
    
    private func setupLayoutAndConstraints() {
        addSubview(coverImageView)
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: coverImageHeight),
            
            contentStackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    private func authorButtonDidTapped() {
        onAuthorTap?()
    }
}

