//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 26.09.2026.
//

import UIKit
import Kingfisher

final class CurrencyCell: UICollectionViewCell, ReuseIdentifying {
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaGreenUniversal
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        contentView.layer.borderColor = nil
        contentView.layer.borderWidth = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(
        imageURL: String,
        title: String,
        subtitle: String,
        isSelected: Bool
    ) {
        imageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: UIImage(resource: .deleteAlert)
        )
        titleLabel.text = title
        subtitleLabel.text = subtitle
        configureCellBorder(isVisible: isSelected)
    }
    
    func configureCellBorder(isVisible: Bool) {
        if isVisible {
            contentView.layer.borderColor = UIColor.segmentActive.cgColor
            contentView.layer.borderWidth = 1.0
        } else {
            contentView.layer.borderColor = nil
            contentView.layer.borderWidth = 0
        }
    }
    
    private func setupView() {
        backgroundColor = .segmentInactive
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
}
